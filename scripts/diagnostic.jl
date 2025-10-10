#!/usr/bin/env julia

# Minimal diagnostic script
println("🔍 DataMind Diagnostic")
println("=" ^ 30)

try
    println("1. Testing basic Julia...")
    using Dates, UUIDs, Random
    println("✅ Standard library imports OK")
    
    println("2. Testing package imports...")
    using CSV, DataFrames, Statistics, HTTP, JSON3, YAML
    println("✅ Package imports OK")
    
    println("3. Testing file structure...")
    println("  Current directory: $(pwd())")
    
    # Get project root directory (parent of scripts directory)
    script_dir = dirname(@__FILE__)
    project_root = dirname(script_dir)
    
    println("  Project root: $project_root")
    println("  DataMind.jl exists: $(isfile(joinpath(project_root, "src", "DataMind.jl")))")
    println("  Config exists: $(isfile(joinpath(project_root, "config", "agents.yaml")))")
    println("  Data directory exists: $(isdir(joinpath(project_root, "data")))")
    
    println("4. Testing basic module load...")
    include(joinpath(project_root, "src", "types.jl"))
    println("✅ Types loaded")
    
    println("5. Creating simple experiment...")
    exp = Experiment("test")
    println("✅ Experiment created: $(exp.id)")
    
    println("6. Testing data loading...")
    sample_data_path = joinpath(project_root, "data", "sample_data.csv")
    if isfile(sample_data_path)
        include(joinpath(project_root, "src", "data", "loader.jl"))
        using .DataLoader
        df, info = DataLoader.load_csv(sample_data_path)
        println("✅ CSV loading test passed")
        println("  Loaded $(info["shape"][1]) rows with $(info["shape"][2]) columns")
    else
        println("⚠️  Sample data file not found at: $sample_data_path")
    end
    
    println("\n🎉 Basic system is working!")
    
catch e
    println("❌ Error: $e")
    println("📍 Type: $(typeof(e))")
    if isa(e, LoadError)
        println("📄 File: $(e.file)")
        println("📍 Line: $(e.line)")
    end
end