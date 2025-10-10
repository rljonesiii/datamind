#!/usr/bin/env julia

# Neo4j Setup Helper for DSAssist

using Pkg
Pkg.activate(".")

println("🔧 DSAssist Neo4j Setup Helper")
println("=" ^ 40)

function check_env_file()
    env_path = ".env"
    if !isfile(env_path)
        println("❌ .env file not found!")
        println("📝 Creating .env file template...")
        
        env_template = """
# LLM API Keys
OPENAI_API_KEY=your_openai_key_here
ANTHROPIC_API_KEY=your_anthropic_key_here

# Optional: Custom LLM endpoints
CUSTOM_LLM_ENDPOINT=http://localhost:8000

# Execution environment
JULIA_NUM_THREADS=4
PYTHON_ENV_PATH=/path/to/your/python/env

# Knowledge graph (Neo4j configuration)
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=your_neo4j_password_here

# Redis for message bus (if using distributed setup)
REDIS_URL=redis://localhost:6379

# Monitoring and logging
LOG_LEVEL=INFO
"""
        
        write(env_path, env_template)
        println("✅ Created .env template at $env_path")
        println("📝 Please edit the file and add your actual credentials")
        return false
    else
        println("✅ .env file found")
        return true
    end
end

function load_env_vars()
    env_vars = Dict{String, String}()
    
    if isfile(".env")
        for line in readlines(".env")
            line = strip(line)
            if !isempty(line) && !startswith(line, "#") && contains(line, "=")
                key, value = split(line, "=", limit=2)
                env_vars[strip(key)] = strip(value)
                ENV[strip(key)] = strip(value)
            end
        end
    end
    
    return env_vars
end

function check_neo4j_config(env_vars)
    println("\n🗃️  Checking Neo4j Configuration")
    println("-" ^ 30)
    
    required_keys = ["NEO4J_URI", "NEO4J_USER", "NEO4J_PASSWORD"]
    missing_keys = String[]
    
    for key in required_keys
        value = get(env_vars, key, "")
        if isempty(value) || contains(value, "your_") || contains(value, "_here")
            push!(missing_keys, key)
            println("❌ $key: not configured")
        else
            # Mask password for display
            display_value = key == "NEO4J_PASSWORD" ? "***" : value
            println("✅ $key: $display_value")
        end
    end
    
    if !isempty(missing_keys)
        println("\n⚠️  Missing Neo4j configuration:")
        for key in missing_keys
            if key == "NEO4J_PASSWORD"
                println("   • $key: Set this to your Neo4j database password")
            else
                println("   • $key: Check your Neo4j instance settings")
            end
        end
        println("\n💡 Tip: Run the credential discovery script:")
        println("   julia --project=. scripts/discover_neo4j_credentials.jl")
        return false
    end
    
    return true
end

function test_neo4j_connection()
    println("\n🔌 Testing Neo4j Connection")
    println("-" ^ 25)
    
    try
        # Test the connection by creating a knowledge graph
        script_dir = dirname(@__FILE__)
        project_root = dirname(script_dir)
        include(joinpath(project_root, "src", "DSAssist.jl"))
        
        # Import the module in a way that works at function level
        Main.eval(:(using .DSAssist))
        kg = Main.eval(:(KnowledgeGraph()))
        
        if kg.neo4j_backend !== nothing
            println("✅ Neo4j connection successful!")
            println("🎉 Your DSAssist system is ready to use Neo4j knowledge graph")
            return true
        else
            println("⚠️  Using in-memory fallback")
            println("💡 Check your Neo4j configuration and try again")
            return false
        end
        
    catch e
        println("❌ Connection test failed: $e")
        println("💡 Please check your Neo4j instance is running and credentials are correct")
        return false
    end
end

function run_setup()
    println("Starting DSAssist Neo4j setup...\n")
    
    # Step 1: Check .env file
    if !check_env_file()
        println("\n🚨 Setup incomplete - please configure your .env file first")
        return false
    end
    
    # Step 2: Load environment variables
    env_vars = load_env_vars()
    
    # Step 3: Check Neo4j configuration
    if !check_neo4j_config(env_vars)
        println("\n🚨 Setup incomplete - please configure Neo4j credentials")
        return false
    end
    
    # Step 4: Test connection
    if test_neo4j_connection()
        println("\n🎉 Setup completed successfully!")
        println("\n📚 Next steps:")
        println("   • Run basic test: julia --project=. scripts/test_neo4j_integration.jl")
        println("   • Run advanced test: julia --project=. scripts/test_neo4j_advanced.jl")
        println("   • Read documentation: docs/neo4j_integration.md")
        return true
    else
        println("\n🚨 Setup incomplete - Neo4j connection failed")
        return false
    end
end

# Run the setup
if run_setup()
    exit(0)
else
    exit(1)
end