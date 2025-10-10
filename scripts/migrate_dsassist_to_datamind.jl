#!/usr/bin/env julia

"""
Migration script to rename DataMind node labels to DataMifunction migrate_dsassist_to_datamind()
    println("🔄 Starting migration from DSAssist to DataMind...")
    
    # Check if old nodes exist
    dsassist_exp_count = get_node_count("DSAssistExperiment")
    dsassist_iter_count = get_node_count("DSAssistIteration")
    
    if dsassist_exp_count == 0 && dsassist_iter_count == 0
        println("✅ No DSAssist nodes found. Migration not needed.")
        return true
    end database.

This script will:
1. Update DataMindExperiment nodes to DataMindExperiment
2. Update DataMindIteration nodes to DataMindIteration  
3. Update constraint and index names
4. Preserve all data and relationships

Run this after updating the codebase from DataMind to DataMind.
"""

# Activate project environment
import Pkg
Pkg.activate(dirname(@__DIR__))

using HTTP, JSON3
import Base64: base64encode

# Configuration
const NEO4J_URI = get(ENV, "NEO4J_URI", "http://localhost:7474")
const NEO4J_USER = get(ENV, "NEO4J_USER", "neo4j") 
const NEO4J_PASSWORD = get(ENV, "NEO4J_PASSWORD", "")

function execute_cypher(query::String, parameters::Dict{String, Any}=Dict{String, Any}())
    if isempty(NEO4J_PASSWORD)
        error("NEO4J_PASSWORD environment variable must be set")
    end
    
    # Convert bolt URI to HTTP URI if needed
    uri = NEO4J_URI
    if startswith(uri, "bolt://")
        # Convert bolt://localhost:7687 to http://localhost:7474
        uri = replace(uri, "bolt://" => "http://", ":7687" => ":7474")
    end
    
    # Prepare HTTP request
    endpoint = uri * "/db/neo4j/tx/commit"
    auth_header = "Basic " * base64encode("$(NEO4J_USER):$(NEO4J_PASSWORD)")
    headers = [
        "Authorization" => auth_header,
        "Content-Type" => "application/json",
        "Accept" => "application/json"
    ]
    
    body = JSON3.write(Dict(
        "statements" => [Dict(
            "statement" => query,
            "parameters" => parameters
        )]
    ))
    
    try
        response = HTTP.post(endpoint, headers, body)
        result = JSON3.read(String(response.body))
        
        if haskey(result, "errors") && !isempty(result.errors)
            error_msg = join([err.message for err in result.errors], "; ")
            throw(ArgumentError("Neo4j query failed: $error_msg"))
        end
        
        return result
    catch e
        @error "Failed to execute Neo4j query" query=query error=e
        throw(e)
    end
end

function get_node_count(label::String)
    query = "MATCH (n:$label) RETURN count(n) as count"
    result = execute_cypher(query)
    
    if haskey(result, "results") && !isempty(result.results)
        data = result.results[1].data
        if !isempty(data)
            return data[1].row[1]
        end
    end
    return 0
end

function migrate_dsassist_to_datamind()
    println("🔄 Starting migration from DataMind to DataMind...")
    
    # Check if old nodes exist
    dsassist_exp_count = get_node_count("DataMindExperiment")
    dsassist_iter_count = get_node_count("DataMindIteration")
    
    if dsassist_exp_count == 0 && dsassist_iter_count == 0
        println("✅ No DataMind nodes found. Migration not needed.")
        return
    end
    
    println("📊 Found $dsassist_exp_count DataMindExperiment nodes and $dsassist_iter_count DataMindIteration nodes")
    
    # 1. Update DataMindExperiment nodes to DataMindExperiment
    if dsassist_exp_count > 0
        println("🔄 Migrating DataMindExperiment nodes to DataMindExperiment...")
        
        migration_query = """
        MATCH (old:DataMindExperiment)
        CREATE (new:DataMindExperiment)
        SET new = properties(old)
        WITH old, new
        MATCH (old)-[r]->(other)
        CREATE (new)-[r2:TYPE(r)]->(other)
        SET r2 = properties(r)
        WITH old, new
        MATCH (other)-[r]->(old)
        CREATE (other)-[r2:TYPE(r)]->(new)
        SET r2 = properties(r)
        WITH old
        DETACH DELETE old
        """
        
        try
            execute_cypher(migration_query)
            new_count = get_node_count("DataMindExperiment")
            println("✅ Successfully migrated $new_count experiment nodes")
        catch e
            @error "Failed to migrate experiment nodes" error=e
            return false
        end
    end
    
    # 2. Update DataMindIteration nodes to DataMindIteration
    if dsassist_iter_count > 0
        println("🔄 Migrating DataMindIteration nodes to DataMindIteration...")
        
        migration_query = """
        MATCH (old:DataMindIteration)
        CREATE (new:DataMindIteration)
        SET new = properties(old)
        WITH old, new
        MATCH (old)-[r]->(other)
        CREATE (new)-[r2:TYPE(r)]->(other)
        SET r2 = properties(r)
        WITH old, new
        MATCH (other)-[r]->(old)
        CREATE (other)-[r2:TYPE(r)]->(new)
        SET r2 = properties(r)
        WITH old
        DETACH DELETE old
        """
        
        try
            execute_cypher(migration_query)
            new_count = get_node_count("DataMindIteration")
            println("✅ Successfully migrated $new_count iteration nodes")
        catch e
            @error "Failed to migrate iteration nodes" error=e
            return false
        end
    end
    
    # 3. Drop old constraints (they may not exist, so we ignore errors)
    println("🔄 Cleaning up old constraints...")
    old_constraints = [
        "DROP CONSTRAINT dsassist_experiment_id IF EXISTS",
        "DROP CONSTRAINT dsassist_iteration_id IF EXISTS", 
        "DROP CONSTRAINT dsassist_pattern_id IF EXISTS",
        "DROP CONSTRAINT dsassist_technique_name IF EXISTS",
        "DROP CONSTRAINT dsassist_domain_name IF EXISTS"
    ]
    
    for constraint in old_constraints
        try
            execute_cypher(constraint)
            println("✅ Dropped constraint: $constraint")
        catch e
            println("⚠️  Constraint may not exist (this is ok): $constraint")
        end
    end
    
    # 4. Drop old indexes (they may not exist, so we ignore errors)
    println("🔄 Cleaning up old indexes...")
    old_indexes = [
        "DROP INDEX dsassist_experiment_question IF EXISTS",
        "DROP INDEX dsassist_iteration_success IF EXISTS",
        "DROP INDEX dsassist_experiment_created IF EXISTS", 
        "DROP INDEX dsassist_experiment_domain IF EXISTS",
        "DROP INDEX dsassist_technique_category IF EXISTS",
        "DROP INDEX dsassist_pattern_category IF EXISTS"
    ]
    
    for index in old_indexes
        try
            execute_cypher(index)
            println("✅ Dropped index: $index")
        catch e
            println("⚠️  Index may not exist (this is ok): $index")
        end
    end
    
    # 5. Create new constraints and indexes
    println("🔄 Creating new DataMind constraints and indexes...")
    new_schema = [
        "CREATE CONSTRAINT datamind_experiment_id IF NOT EXISTS FOR (e:DataMindExperiment) REQUIRE e.id IS UNIQUE",
        "CREATE CONSTRAINT datamind_iteration_id IF NOT EXISTS FOR (i:DataMindIteration) REQUIRE (i.experiment_id, i.iteration) IS UNIQUE",
        "CREATE INDEX datamind_experiment_question IF NOT EXISTS FOR (e:DataMindExperiment) ON (e.research_question)",
        "CREATE INDEX datamind_iteration_success IF NOT EXISTS FOR (i:DataMindIteration) ON (i.success)",
        "CREATE INDEX datamind_experiment_created IF NOT EXISTS FOR (e:DataMindExperiment) ON (e.created_at)",
        "CREATE INDEX datamind_experiment_domain IF NOT EXISTS FOR (e:DataMindExperiment) ON (e.domain_tags)"
    ]
    
    for schema_item in new_schema
        try
            execute_cypher(schema_item)
            println("✅ Created: $schema_item")
        catch e
            println("⚠️  May already exist: $schema_item")
        end
    end
    
    # 6. Verify migration
    println("🔍 Verifying migration...")
    final_exp_count = get_node_count("DataMindExperiment")
    final_iter_count = get_node_count("DataMindIteration")
    remaining_dsassist_exp = get_node_count("DataMindExperiment")
    remaining_dsassist_iter = get_node_count("DataMindIteration")
    
    println("📊 Migration Results:")
    println("   • DataMindExperiment nodes: $final_exp_count")
    println("   • DataMindIteration nodes: $final_iter_count") 
    println("   • Remaining DataMindExperiment nodes: $remaining_dsassist_exp")
    println("   • Remaining DataMindIteration nodes: $remaining_dsassist_iter")
    
    if remaining_dsassist_exp == 0 && remaining_dsassist_iter == 0
        println("🎉 Migration completed successfully!")
        return true
    else
        println("❌ Migration incomplete - some old nodes remain")
        return false
    end
end

# Check if running as script
if abspath(PROGRAM_FILE) == @__FILE__
    println("🚀 DataMind Neo4j Migration Script")
    println("=====================================")
    
    if isempty(NEO4J_PASSWORD)
        println("❌ Please set NEO4J_PASSWORD environment variable")
        println("   export NEO4J_PASSWORD=your_password")
        exit(1)
    end
    
    try
        success = migrate_dsassist_to_datamind()
        if success
            println("\n✅ Migration completed successfully!")
            exit(0)
        else
            println("\n❌ Migration failed!")
            exit(1)
        end
    catch e
        println("\n💥 Migration error: $e")
        exit(1)
    end
end