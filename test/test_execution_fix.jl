#!/usr/bin/env julia

# Quick test of the fixed execution sandbox
println("🧪 Testing Fixed Execution Sandbox")
println("=" ^ 40)

using Pkg
Pkg.activate(".")

include("src/execution/sandbox.jl")

# Test the fixed execute_code function 
try
    # Test with simple working code
    test_result = execute_code("""
    using Statistics
    data = [1, 2, 3, 4, 5]
    mean_val = mean(data)
    println("Mean: ", mean_val)
    println("Success!")
    """)
    
    println("✅ Test Result:")
    println("  Success: ", test_result.success)
    println("  Output: ", repr(test_result.output))
    println("  Error: ", test_result.error)
    
    if test_result.success
        println("🎉 Execution sandbox is now working!")
    else
        println("❌ Still having issues: ", test_result.error)
    end
    
catch e
    println("❌ Test failed: ", e)
end