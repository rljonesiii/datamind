#!/usr/bin/env julia

# Direct Neo4j Database Query Test

using Pkg
Pkg.activate(".")

# Get the script directory and navigate to project root
script_dir = dirname(@__FILE__)
project_root = dirname(script_dir)
cd(project_root)

# Load environment variables from .env file
function load_env_file(filepath=".env")
    if isfile(filepath)
        for line in readlines(filepath)
            line = strip(line)
            if !isempty(line) && !startswith(line, "#") && contains(line, "=")
                key, value = split(line, "=", limit=2)
                ENV[strip(key)] = strip(value)
            end
        end
    end
end

load_env_file()

using HTTP, JSON3, Base64

function test_direct_neo4j_queries()
    println("🔍 Direct Neo4j Database Query Test")
    println("=" ^ 40)
    
    # Get Neo4j connection details
    uri = get(ENV, "NEO4J_URI", "bolt://localhost:7687")
    if startswith(uri, "bolt://")
        uri = replace(uri, "bolt://" => "http://", ":7687" => ":7474")
    end
    user = get(ENV, "NEO4J_USER", "neo4j")
    password = get(ENV, "NEO4J_PASSWORD", "")
    
    if isempty(password)
        println("❌ Neo4j password not configured")
        return false
    end
    
    # Create authorization header
    auth = base64encode("$user:$password")
    headers = [
        "Authorization" => "Basic $auth",
        "Content-Type" => "application/json",
        "Accept" => "application/json"
    ]
    
    endpoint = "$uri/db/neo4j/tx/commit"
    
    println("🔌 Connecting to: $uri")
    println("👤 User: $user")
    
    try
        # Query 1: Count all DSAssist nodes
        println("\n📊 Query 1: Counting DSAssist experiments...")
        query1 = """
        MATCH (e:DSAssistExperiment)
        RETURN count(e) as experiment_count
        """
        
        body1 = JSON3.write(Dict(
            "statements" => [Dict(
                "statement" => query1,
                "parameters" => Dict()
            )]
        ))
        
        response1 = HTTP.post(endpoint, headers, body1)
        result1 = JSON3.read(String(response1.body))
        
        if haskey(result1, "results") && !isempty(result1["results"])
            data = result1["results"][1]["data"]
            if !isempty(data)
                count = data[1]["row"][1]
                println("✅ Found $count DSAssist experiments in database")
            else
                println("📭 No experiments found in database")
            end
        end
        
        # Query 2: List recent experiments
        println("\n📊 Query 2: Recent experiments...")
        query2 = """
        MATCH (e:DSAssistExperiment)
        RETURN e.id, e.research_question, e.created_at, e.status
        ORDER BY e.created_at DESC
        LIMIT 5
        """
        
        body2 = JSON3.write(Dict(
            "statements" => [Dict(
                "statement" => query2,
                "parameters" => Dict()
            )]
        ))
        
        response2 = HTTP.post(endpoint, headers, body2)
        result2 = JSON3.read(String(response2.body))
        
        if haskey(result2, "results") && !isempty(result2["results"])
            data = result2["results"][1]["data"]
            if !isempty(data)
                println("📝 Recent experiments:")
                for row in data
                    id, question, created_at, status = row["row"]
                    short_question = length(question) > 50 ? question[1:47] * "..." : question
                    println("   • $short_question")
                    println("     ID: $id | Status: $status")
                end
            end
        end
        
        # Query 3: Count iterations and success rate
        println("\n📊 Query 3: Iteration statistics...")
        query3 = """
        MATCH (i:DSAssistIteration)
        RETURN 
            count(i) as total_iterations,
            sum(case when i.success then 1 else 0 end) as successful_iterations,
            avg(case when i.success then 1.0 else 0.0 end) as success_rate
        """
        
        body3 = JSON3.write(Dict(
            "statements" => [Dict(
                "statement" => query3,
                "parameters" => Dict()
            )]
        ))
        
        response3 = HTTP.post(endpoint, headers, body3)
        result3 = JSON3.read(String(response3.body))
        
        if haskey(result3, "results") && !isempty(result3["results"])
            data = result3["results"][1]["data"]
            if !isempty(data)
                total, successful, rate = data[1]["row"]
                println("📈 Iteration Statistics:")
                println("   • Total iterations: $total")
                println("   • Successful iterations: $successful")
                println("   • Success rate: $(round(rate * 100, digits=1))%")
            end
        end
        
        # Query 4: Most common metrics
        println("\n📊 Query 4: Most common metrics...")
        query4 = """
        MATCH (i:DSAssistIteration)
        UNWIND keys(i.metrics) as metric_name
        RETURN metric_name, count(*) as usage_count
        ORDER BY usage_count DESC
        LIMIT 5
        """
        
        body4 = JSON3.write(Dict(
            "statements" => [Dict(
                "statement" => query4,
                "parameters" => Dict()
            )]
        ))
        
        response4 = HTTP.post(endpoint, headers, body4)
        result4 = JSON3.read(String(response4.body))
        
        if haskey(result4, "results") && !isempty(result4["results"])
            data = result4["results"][1]["data"]
            if !isempty(data)
                println("📊 Most Common Metrics:")
                for row in data
                    metric, count = row["row"]
                    println("   • $metric: used $count times")
                end
            end
        end
        
        println("\n🎉 Direct Neo4j query test completed successfully!")
        return true
        
    catch e
        println("❌ Query test failed: $e")
        return false
    end
end

# Run the test
if test_direct_neo4j_queries()
    println("\n✅ All direct queries completed successfully!")
    exit(0)
else
    println("\n❌ Direct query test failed!")
    exit(1)
end