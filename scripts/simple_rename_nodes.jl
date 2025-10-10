#!/usr/bin/env julia

"""
Simple script to rename DSAssist node labels to DataMind in Neo4j database.
"""

# Activate project environment
import Pkg
Pkg.activate(dirname(@__DIR__))

using HTTP, JSON3
import Base64: base64encode

# Configuration
const NEO4J_USER = get(ENV, "NEO4J_USER", "neo4j") 
const NEO4J_PASSWORD = get(ENV, "NEO4J_PASSWORD", "")
const NEO4J_URI = get(ENV, "NEO4J_URI", "bolt://localhost:7687")

function execute_cypher(query::String)
    if isempty(NEO4J_PASSWORD)
        error("NEO4J_PASSWORD environment variable must be set")
    end
    
    # Convert bolt URI to HTTP URI if needed
    uri = NEO4J_URI
    if startswith(uri, "bolt://")
        uri = replace(uri, "bolt://" => "http://", ":7687" => ":7474")
    end
    
    # Prepare HTTP request
    endpoint = uri * "/db/neo4j/tx/commit"
    auth_header = "Basic " * base64encode("$(NEO4J_USER):$(NEO4J_PASSWORD)")
    headers = [
        "Authorization" => auth_header,
        "Content-Type" => "application/json"
    ]
    
    body = JSON3.write(Dict(
        "statements" => [Dict("statement" => query)]
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

# Simple queries to rename node labels
queries = [
    # Rename DSAssistExperiment to DataMindExperiment
    """
    MATCH (n:DSAssistExperiment)
    SET n:DataMindExperiment
    REMOVE n:DSAssistExperiment
    """,
    
    # Rename DSAssistIteration to DataMindIteration  
    """
    MATCH (n:DSAssistIteration)
    SET n:DataMindIteration
    REMOVE n:DSAssistIteration
    """
]

println("🔄 Renaming DSAssist nodes to DataMind...")

for (i, query) in enumerate(queries)
    try
        println("Executing query $i...")
        execute_cypher(query)
        println("✅ Query $i completed successfully")
    catch e
        println("❌ Query $i failed: $e")
    end
end

println("🎉 Migration completed!")