#!/usr/bin/env julia

# Test script to verify real LLM API calls work
using Pkg
Pkg.activate(".")

println("🧪 Testing DSAssist with Real API Calls")
println("=" ^ 50)

# Set environment variable for real API calls
ENV["DSASSIST_USE_REAL_API"] = "true"

try
    # Include DSAssist modules directly
    include("src/utils/llm_client.jl")
    
    # Test LLM client configuration
    config = (
        name = "test_agent",
        llm_model = "gpt-4",
        temperature = 0.3,
        max_tokens = 500,
        retry_count = 3,
        system_prompt = "You are a helpful data science assistant."
    )
    
    # Create LLM client
    client = LLMClient(config)
    
    println("✓ LLM Client created successfully")
    println("✓ Using model: $(client.config.llm_model)")
    println("✓ API key present: $(length(client.api_key) > 0 ? "Yes" : "No")")
    
    # Test a simple call
    println("\n🚀 Testing API call...")
    test_prompt = "Analyze this sample data: [1,2,3,4,5]. What patterns do you see?"
    
    response = call_llm(client, test_prompt)
    
    println("✓ API call successful!")
    println("📄 Response preview:")
    println(response[1:min(200, length(response))] * (length(response) > 200 ? "..." : ""))
    
    # Check if response looks real (not mock)
    if contains(response, "correlation_coeff") && contains(response, "0.23")
        println("❌ Still getting mock responses!")
        println("Make sure DSASSIST_USE_REAL_API=true is set")
    else
        println("✅ Getting real API responses!")
    end
    
catch e
    println("❌ Error testing API: $e")
    if isa(e, MethodError)
        println("💡 This might be a dependency issue. Try: Pkg.instantiate()")
    end
end