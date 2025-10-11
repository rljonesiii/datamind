"""
    CodeGenAgent

Generates focused Python/Julia code snippets to test specific hypotheses.
"""
struct CodeGenAgent
    config::AgentConfig
    llm_client::LLMClient
    
    function CodeGenAgent(config::Dict)
        agent_config = AgentConfig(
            "codegen_agent",
            get(config, "model", "gpt-4"),
            get(config, "temperature", 0.1),
            get(config, "max_tokens", 2000),
            get(config, "system_prompt", codegen_system_prompt()),
            get(config, "retry_count", 3)
        )
        
        llm_client = LLMClient(agent_config)
        new(agent_config, llm_client)
    end
end

"""
    generate_code(agent::CodeGenAgent, plan::Dict, experiment::Experiment)

Generates executable code based on the planning agent's output.
"""
function generate_code(agent::CodeGenAgent, plan::Dict, experiment::Experiment)
    context = build_code_context(experiment)
    
    prompt = """
    🚨 CRITICAL: When loading data files, ALWAYS use data_path("filename.csv") function!
    Example: df = CSV.read(data_path("cc_data.csv"), DataFrame)
    NEVER use "data/file.csv" - this will fail! Use data_path() function!
    
    Generate Julia code to test this hypothesis:
    
    Hypothesis: $(plan["hypothesis"])
    Steps: $(join(plan["steps"], ", "))
    Expected Outcome: $(plan["expected_outcome"])
    Success Metrics: $(join(plan["success_metrics"], ", "))
    
    Context from previous iterations:
    $context
    
    Requirements:
    You are an expert Julia data scientist who generates bulletproof, error-free code.

🚨🚨🚨 ABSOLUTE DATAFRAME PROHIBITION 🚨🚨🚨
ATTENTION: You are generating code for Julia DataFrames.jl - NOT Python pandas!
Julia DataFrames have COMPLETELY DIFFERENT iteration rules!

⛔ THE FOLLOWING CODE WILL 100% CRASH AND FAIL:
```julia
# ❌ FORBIDDEN - DO NOT WRITE THIS CODE:
for row in df
    # This crashes with "AbstractDataFrame is not iterable"
end

for col in df  
    # This also crashes
end

# ❌ FORBIDDEN - DO NOT ASSUME COLUMN NAMES:
df.product_price  # Column might not exist!
df.sales_volume   # Column might not exist!
row.SOME_COLUMN   # Always check column names first!

# ❌ FORBIDDEN - Any direct iteration on df
```

🚨 CRITICAL: NEVER ASSUME COLUMN NAMES! ALWAYS CHECK FIRST!
```julia
# ❌ WRONG - Assuming columns exist:
mean(df.product_price)  # Will crash if column doesn't exist

# ✅ CORRECT - Check columns first:
println("Available columns: ", names(df))
if "price" in names(df)
    mean(df.price)  # Safe to use
else
    error("Price column not found")
end
```

✅ THE ONLY CORRECT WAY TO ITERATE:
```julia
# ✅ CORRECT - For rows:
for row in eachrow(df)
    println(row.BALANCE)  # This works
end

# ✅ CORRECT - For columns:  
for col in eachcol(df)
    println(mean(col))  # This works
end
```

Your task is to generate Julia code that:
    - Write complete, executable Julia code
    - Include necessary imports (using CSV, DataFrames, Statistics, etc.)
    - CRITICAL: For data files, ALWAYS use data_path("filename.csv") function (automatically provided)
    - Example: df = CSV.read(data_path("cc_data.csv"), DataFrame)
    - NEVER use relative paths like "data/file.csv" - always use data_path() function
    
    🚨 STRICT DATAFRAME RULES (REQUIRED):
    
    ❌ NEVER DO THESE (WILL CAUSE ERRORS):
    - for row in df  ❌❌❌ FORBIDDEN
    - for col in df  ❌❌❌ FORBIDDEN  
    - for i in df    ❌❌❌ FORBIDDEN
    - iterate(df)    ❌❌❌ FORBIDDEN
    - @load          ❌❌❌ FORBIDDEN
    
    ✅ ALWAYS DO THESE (SAFE PATTERNS):
    - for row in eachrow(df) ✅✅✅ REQUIRED
    - for col in eachcol(df) ✅✅✅ REQUIRED
    - df[!, :column_name] ✅✅✅ REQUIRED
    - select(df, [:col1, :col2]) ✅✅✅ REQUIRED
    
    🔒 MANDATORY CODE STRUCTURE:
    1. ALWAYS start with: df = CSV.read(data_path("cc_data.csv"), DataFrame)
    2. ALWAYS check: println("Data loaded: ", size(df))
    3. For iteration: ONLY use eachrow(df) or eachcol(df)
    4. For ML: use explicit imports, never @load macro
    
    🚨 VARIABLE SCOPE RULES (REQUIRED):
    - ALWAYS define variables before use
    - Load data FIRST: df = CSV.read(data_path("cc_data.csv"), DataFrame)
    - Check data: println("Data loaded: ", size(df))
    - Then proceed with analysis
    
    🚨 PACKAGE IMPORT RULES (REQUIRED):
    - NEVER use @load macro ❌
    - ALWAYS use explicit imports ✅
    - Available: CSV, DataFrames, Statistics, StatsBase, GLM, Plots, HypothesisTests, MLJ, Clustering
    - Example: using GLM; model = lm(@formula(y ~ x), data) ✅
    
    🚨 COLUMN NAME RULES (REQUIRED):
    - Check column names first: names(df)
    - Use exact column names from data
    - Common credit card columns: BALANCE, PURCHASES, CASH_ADVANCE, CREDIT_LIMIT
    - Common product sales columns: product_id, product_name, category, price, rating, reviews_count, in_stock
    - Common weather columns: city, temperature, humidity, pressure, weather_condition
    - NEVER assume column names ❌
    - ALWAYS verify with: println("Columns: ", names(df)) ✅
    
    🚨 TESTED CODE TEMPLATES (COPY THESE PATTERNS):
    
    📊 Data Loading Template:
    ```julia
    using CSV, DataFrames, Statistics
    df = CSV.read(data_path("filename.csv"), DataFrame)
    println("Data loaded: ", size(df))
    println("Columns: ", names(df))
    
    # CRITICAL: Always check actual column names before using them
    actual_columns = names(df)
    println("Available columns: ", actual_columns)
    ```
    
    📊 Safe Column Access Template:
    ```julia
    # ALWAYS check columns exist before using them
    if "price" in names(df)
        println("Price column found - proceeding with analysis")
        price_mean = mean(df.price)
    else
        println("Available columns: ", names(df))
        error("Price column not found in data")
    end
    ```
    
    📊 Data Exploration Template:
    ```julia
    # Check data shape and columns FIRST
    println("Shape: ", size(df))
    println("Columns: ", names(df))
    
    # Iterate rows safely
    for (i, row) in enumerate(eachrow(df))
        if i <= 3  # Show first 3 rows
            println("Row \$i: ", row)  # Don't assume column names
        end
    end
    
    # Get statistics for ALL numeric columns
    for col_name in names(df)
        if eltype(df[!, col_name]) <: Number
            println("\$col_name mean: ", mean(skipmissing(df[!, col_name])))
        end
    end
    ```
    
    📊 Statistical Analysis Template:
    ```julia
    # Safe column selection
    if "BALANCE" in names(df) && "PURCHASES" in names(df)
        correlation = cor(df.BALANCE, df.PURCHASES)
        println("Correlation: ", correlation)
    end
    
    # Summary statistics
    balance_mean = mean(skipmissing(df.BALANCE))
    balance_std = std(skipmissing(df.BALANCE))
    println("Balance: \$balance_mean ± \$balance_std")
    ```
    
    - For numerical analysis, filter to numeric columns: numeric_cols = select(df, findall(col -> eltype(df[!, col]) <: Number, names(df)))
    - Handle data loading/generation if needed
    - Calculate the specified success metrics
    - Print results clearly with metric names and values
    - Keep it under 50 lines
    - Use DataFrames, Plots, Statistics for data work
    - If working with CSV data, use CSV.read() to load it
    
    Return only the code, no explanations.
    """
    
    code = call_llm(agent.llm_client, prompt)
    return clean_code_response(code)
end

"""
    build_code_context(experiment::Experiment)

Builds context for code generation from previous successful attempts.
"""
function build_code_context(experiment::Experiment)
    context_parts = String[]
    
    # Include data file information
    if haskey(experiment.context, "data_file")
        data_file = experiment.context["data_file"]
        push!(context_parts, "Data file: $data_file")
        push!(context_parts, "IMPORTANT: Use data_path(\"$(basename(data_file))\") to load data files")
        push!(context_parts, "Example: df = CSV.read(data_path(\"$(basename(data_file))\"), DataFrame)")
        
        if haskey(experiment.context, "data_shape")
            push!(context_parts, "Data shape: $(experiment.context["data_shape"])")
        end
        
        if haskey(experiment.context, "columns")
            push!(context_parts, "Columns: $(join(experiment.context["columns"], ", "))")
        end
        
        if haskey(experiment.context, "numeric_columns") && !isempty(experiment.context["numeric_columns"])
            push!(context_parts, "Numeric columns: $(join(experiment.context["numeric_columns"], ", "))")
        end
        
        if haskey(experiment.context, "categorical_columns") && !isempty(experiment.context["categorical_columns"])
            push!(context_parts, "Categorical columns: $(join(experiment.context["categorical_columns"], ", "))")
        end
    end
    
    # Include successful patterns
    if haskey(experiment.context, "successful_patterns")
        push!(context_parts, "Previously successful imports/patterns:")
        for pattern in experiment.context["successful_patterns"]
            push!(context_parts, pattern)
        end
    end
    
    # Include variable definitions from previous runs
    if haskey(experiment.context, "variables")
        push!(context_parts, "Available variables: $(join(keys(experiment.context["variables"]), ", "))")
    end
    
    return join(context_parts, "\n")
end

"""
    clean_code_response(code::String)

Cleans LLM response to extract just the code.
"""
function clean_code_response(code::String)
    # Remove markdown code blocks
    cleaned = replace(code, r"```julia\n?" => "")
    cleaned = replace(cleaned, r"```\n?" => "")
    
    # Remove any explanatory text before/after code
    lines = split(cleaned, "\n")
    code_lines = String[]
    
    in_code = false
    for line in lines
        # Start collecting when we see import/using or function definitions
        if !in_code && (startswith(strip(line), "using") || 
                       startswith(strip(line), "import") ||
                       startswith(strip(line), "function") ||
                       contains(line, "=") && !startswith(strip(line), "#"))
            in_code = true
        end
        
        if in_code
            push!(code_lines, line)
        end
    end
    
    return join(code_lines, "\n")
end

"""
    codegen_system_prompt()

System prompt for the code generation agent.
"""
function codegen_system_prompt()
    return """
    You are an expert Julia programmer specializing in data science code generation.
    
    Your role is to write minimal, focused code that tests specific hypotheses.
    
    Key principles:
    - Write clean, executable Julia code
    - Use standard data science packages (DataFrames, Plots, StatsPlots, MLJ)
    - Include clear variable names and comments for key steps
    - Always calculate and print the requested metrics
    - Handle errors gracefully with try-catch when appropriate
    - Prefer simple approaches that can be quickly validated
    
    Always return ONLY the code, no explanations or markdown formatting.
    """
end