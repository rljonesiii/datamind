"""
    LLMClient

Handles communication with various LLM providers (OpenAI, Anthropic, etc.)
"""
struct LLMClient
    config::AgentConfig
    api_key::String
    base_url::String
    
    function LLMClient(config::AgentConfig)
        # Determine provider from model name
        if startswith(config.llm_model, "gpt")
            api_key = get(ENV, "OPENAI_API_KEY", "")
            base_url = "https://api.openai.com/v1"
        elseif startswith(config.llm_model, "claude")
            api_key = get(ENV, "ANTHROPIC_API_KEY", "")
            base_url = "https://api.anthropic.com/v1"
        else
            # Default to OpenAI format
            api_key = get(ENV, "OPENAI_API_KEY", "")
            base_url = "https://api.openai.com/v1"
        end
        
        new(config, api_key, base_url)
    end
end

"""
    call_llm(client::LLMClient, prompt::String)

Makes an API call to the configured LLM provider.
"""
function call_llm(client::LLMClient, prompt::String)
    # Check if user wants to force mock responses (for debugging)
    use_mock_api = get(ENV, "DATAMIND_USE_MOCK_API", "false") == "true"
    
    if isempty(client.api_key)
        @warn "No API key found for $(client.config.llm_model). Using mock response."
        return generate_mock_response(client.config.name, prompt)
    end
    
    if use_mock_api
        @info "Using mock response for debugging (DATAMIND_USE_MOCK_API=true set)."
        return generate_mock_response(client.config.name, prompt)
    end
    
    @info "Making real API call to $(client.config.llm_model)..."
    
    # Retry logic with exponential backoff
    for attempt in 1:client.config.retry_count
        try
            if startswith(client.config.llm_model, "gpt")
                return call_openai(client, prompt)
            elseif startswith(client.config.llm_model, "claude")
                return call_anthropic(client, prompt)
            else
                return call_openai(client, prompt)  # Default
            end
        catch e
            @warn "LLM call attempt $attempt failed: $e"
            if attempt == client.config.retry_count
                @error "All API attempts failed, falling back to mock response"
                return generate_mock_response(client.config.name, prompt)
            end
            sleep(2^attempt)  # Exponential backoff
        end
    end
end

"""
    call_openai(client::LLMClient, prompt::String)

Makes API call to OpenAI.
"""
function call_openai(client::LLMClient, prompt::String)
    headers = [
        "Authorization" => "Bearer $(client.api_key)",
        "Content-Type" => "application/json"
    ]
    
    payload = Dict(
        "model" => client.config.llm_model,
        "messages" => [
            Dict("role" => "system", "content" => client.config.system_prompt),
            Dict("role" => "user", "content" => prompt)
        ],
        "temperature" => client.config.temperature,
        "max_tokens" => client.config.max_tokens
    )
    
    response = HTTP.post(
        "$(client.base_url)/chat/completions",
        headers,
        JSON3.write(payload)
    )
    
    result = JSON3.read(String(response.body))
    return result["choices"][1]["message"]["content"]
end

"""
    call_anthropic(client::LLMClient, prompt::String)

Makes API call to Anthropic Claude.
"""
function call_anthropic(client::LLMClient, prompt::String)
    headers = [
        "x-api-key" => client.api_key,
        "Content-Type" => "application/json",
        "anthropic-version" => "2023-06-01"
    ]
    
    # Combine system prompt and user prompt for Claude
    full_prompt = "$(client.config.system_prompt)\n\nUser: $prompt\n\nAssistant:"
    
    payload = Dict(
        "model" => client.config.llm_model,
        "prompt" => full_prompt,
        "temperature" => client.config.temperature,
        "max_tokens_to_sample" => client.config.max_tokens
    )
    
    response = HTTP.post(
        "$(client.base_url)/complete",
        headers,
        JSON3.write(payload)
    )
    
    result = JSON3.read(String(response.body))
    return result["completion"]
end

"""
    generate_mock_response(agent_name::String, prompt::String)

Generates mock responses for testing without API keys.
"""
function generate_mock_response(agent_name::String, prompt::String)
    if agent_name == "planning_agent"
        return JSON3.write(Dict(
            "hypothesis" => "Mock hypothesis: Data feature X correlates with outcome Y",
            "steps" => ["Load data", "Calculate correlation", "Test significance"],
            "expected_outcome" => "Correlation coefficient > 0.5",
            "data_requirements" => ["feature_x", "outcome_y"],
            "success_metrics" => ["correlation_coeff", "p_value"]
        ))
    elseif agent_name == "codegen_agent"
        # Check if we have CSV data context
        if contains(prompt, "data_file") || contains(prompt, "CSV") || contains(prompt, "credit_card") || contains(prompt, "cc_data")
            return """
            using CSV, DataFrames, Statistics
            
            # Load the CSV data
            if isfile("data/cc_data.csv")
                df = CSV.read("data/cc_data.csv", DataFrame)
            elseif isfile("data.csv")
                df = CSV.read("data.csv", DataFrame)
            else
                # Generate sample data for demonstration
                df = DataFrame(
                    CUST_ID = 1:100,
                    BALANCE = rand(100) * 5000,
                    CREDIT_LIMIT = rand(100) * 10000 .+ 1000,
                    PURCHASES = rand(100) * 3000,
                    CASH_ADVANCE = rand(100) * 1000,
                    PAYMENTS = rand(100) * 2000,
                    MINIMUM_PAYMENTS = rand(100) * 500
                )
            end
            
            # Basic data exploration
            data_shape = size(df)
            println("data_shape: ", data_shape)
            println("Data shape: ", data_shape)
            println("Columns: ", names(df))
            
            # Calculate correlation between features
            numeric_cols = [col for col in names(df) if eltype(df[!, col]) <: Number]
            if length(numeric_cols) >= 2
                corr_coeff = cor(df[!, numeric_cols[1]], df[!, numeric_cols[2]])
                println("correlation_coeff: ", round(corr_coeff, digits=3))
            end
            
            # Basic statistics
            for col_name in names(df)
                if eltype(df[!, col_name]) <: Number
                    col_mean = mean(skipmissing(df[!, col_name]))
                    println("\$(col_name)_mean: ", round(col_mean, digits=3))
                end
            end
            
            println("sample_size: ", nrow(df))
            println("feature_count: ", ncol(df))
            """
        else
            return """
            using DataFrames, Statistics
            
            # Generate sample data
            n = 100
            df = DataFrame(
                feature_x = randn(n),
                outcome_y = randn(n)
            )
            
            # Basic data exploration
            data_shape = size(df)
            println("data_shape: ", data_shape)
            println("Data shape: ", data_shape)
            
            # Calculate correlation
            corr_coeff = cor(df.feature_x, df.outcome_y)
            println("correlation_coeff: ", corr_coeff)
            println("sample_size: ", nrow(df))
            println("feature_count: ", ncol(df))
            """
        end
    elseif agent_name == "evaluation_agent"
        return JSON3.write(Dict(
            "success" => true,
            "confidence" => 0.7,
            "metrics" => Dict("correlation_coeff" => 0.23, "sample_size" => 100),
            "summary" => "Found weak correlation between features",
            "next_actions" => ["Try larger sample size", "Test other features"],
            "should_stop" => false,
            "insights" => ["Correlation exists but is weak", "More data might help"]
        ))
    else
        return "Mock response for $agent_name"
    end
end