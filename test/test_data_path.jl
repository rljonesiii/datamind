#!/usr/bin/env julia

# Test data_path function in isolation
using Pkg
Pkg.activate(".")

include("src/DataMind.jl")
using .DataMind

# Create a simple test of the execution sandbox with data_path
code = """
using CSV, DataFrames, Statistics

# Test the data_path function
println("PROJECT_ROOT: ", PROJECT_ROOT)
println("data_path test: ", data_path("cc_data.csv"))

# Try to load the data
df = CSV.read(data_path("cc_data.csv"), DataFrame)
println("Data loaded successfully!")
println("Shape: ", size(df))
println("Columns: ", names(df)[1:5])
"""

sandbox = DataMind.ExecutionSandbox(Dict("timeout" => 30))
result = DataMind.execute_code(sandbox, code)

println("Execution success: ", result.success)
if result.success
    println("Output: ", result.output)
else
    println("Error: ", result.error)
end