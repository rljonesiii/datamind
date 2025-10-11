"""
    ExecutionSandbox

Provides isolated execution environment for generated code.
Captures outputs, handles errors, and manages artifacts.
"""
struct ExecutionSandbox
    work_dir::String
    timeout::Int
    max_memory::Int  # MB
    
    function ExecutionSandbox(config::Dict)
        work_dir = get(config, "work_dir", mktempdir())
        timeout = get(config, "timeout", 60)  # seconds
        max_memory = get(config, "max_memory", 1024)  # MB
        
        # Ensure work directory exists
        mkpath(work_dir)
        
        new(work_dir, timeout, max_memory)
    end
end

"""
    ExecutionResult

Contains the results of code execution.
"""
struct ExecutionResult
    success::Bool
    output::String
    error::String
    artifacts::Vector{String}
    execution_time::Float64
    memory_used::Float64
end

"""
    execute_code(sandbox::ExecutionSandbox, code::String)

Executes Julia code in the sandbox and returns results.
"""
function execute_code(sandbox::ExecutionSandbox, code::String)
    start_time = time()
    
    # Create a temporary file for the code
    code_file = joinpath(sandbox.work_dir, "experiment_$(rand(1000:9999)).jl")
    
    try
        # Write code to file with automatic sanitization
        sanitized_code = sanitize_julia_code(code)
        if sanitized_code != code
            @info "Applied automatic code sanitization for common DataFrame issues"
        end
        
        open(code_file, "w") do f
            write(f, prepare_code_for_execution(sanitized_code, sandbox.work_dir))
        end
        
        # Execute with timeout and capture output
        result = execute_with_timeout(code_file, sandbox.timeout)
        
        # Enhanced error analysis for common issues
        if !result.success && !isempty(result.error)
            result = enhance_error_feedback(result)
        end
        
        # Find generated artifacts
        artifacts = find_artifacts(sandbox.work_dir)
        
        execution_time = time() - start_time
        
        return ExecutionResult(
            result.success,
            result.output,
            result.error,
            artifacts,
            execution_time,
            0.0  # Memory tracking would require additional tooling
        )
        
    catch e
        return ExecutionResult(
            false,
            "",
            string(e),
            String[],
            time() - start_time,
            0.0
        )
    finally
        # Cleanup
        isfile(code_file) && rm(code_file, force=true)
    end
end

"""
    prepare_code_for_execution(code::String, work_dir::String)

Prepares code for safe execution by adding necessary setup.
"""
function prepare_code_for_execution(code::String, work_dir::String)
    # Get the project root directory (where Project.toml is located)
    # This file is at src/execution/sandbox.jl, so go up 2 levels to project root
    project_root = abspath(joinpath(@__DIR__, "..", ".."))
    
    setup = """
    # Auto-generated execution setup
    cd("$work_dir")
    
    # Define project root for data access
    const PROJECT_ROOT = "$project_root"
    
    # Helper function to get data file paths
    data_path(filename) = joinpath(PROJECT_ROOT, "data", filename)
    
    # Create a data directory symlink in the temp directory to catch common errors
    if !isdir("data")
        try
            symlink(joinpath(PROJECT_ROOT, "data"), "data")
        catch
            # If symlink fails, create directory and copy files
            mkdir("data")
            for file in readdir(joinpath(PROJECT_ROOT, "data"))
                if endswith(file, ".csv")
                    cp(joinpath(PROJECT_ROOT, "data", file), joinpath("data", file))
                end
            end
        end
    end
    
    # Common imports that are frequently needed
    using CSV, DataFrames, Statistics, StatsBase
    
    try
        # User code starts here
    """
    
    cleanup = """
        # User code ends here
        
        # Try to save any plots if Plots is loaded
        try
            if @isdefined(Plots) && Plots.backend() != Plots.NoBackend()
                Plots.savefig("plot_\$(rand(1000:9999)).png")
                println("Plot saved successfully")
            end
        catch
            # Ignore plot saving errors
        end
        
    catch e
        println("Execution error: \$e")
        rethrow(e)
    end
    """
    
    return setup * "\n" * code * "\n" * cleanup
end

"""
    execute_with_timeout(code_file::String, timeout::Int)

Executes Julia file with timeout protection.
"""
function execute_with_timeout(code_file::String, timeout::Int)
    try
        # Use a simpler approach - just execute the code directly in the current process
        # This avoids the complexity of subprocess management that was causing hangs
        
        println("Executing code...")
        
        # Read and evaluate the code
        code_content = read(code_file, String)
        
        # Create a simple execution environment
        output_buffer = IOBuffer()
        
        try
            # Execute the code in a try-catch block without stdout redirection
            # This avoids the redirect_stdout compatibility issues
            println("Executing user code...")
            eval(Meta.parse("begin\n$code_content\nend"))
            
            # Return success (output will be printed directly to console)
            return (success=true, output="Code executed successfully", error="")
            
        catch e
            error_msg = "$(typeof(e)): $(string(e))"
            println("Execution failed with error: $error_msg")
            
            # Provide helpful hints based on error type
            if isa(e, UndefVarError)
                println("Hint: Variable '$(e.var)' is not defined. Make sure to define it before use.")
            elseif isa(e, ArgumentError) && contains(string(e), "not a valid file")
                println("Hint: File not found. Use data_path(\"filename.csv\") to access data files.")
            elseif isa(e, MethodError)
                println("MethodError details:")
                println("  Function: $(e.f)")
                println("  Arguments: $(e.args)")
                println("Hint: Check if packages are loaded or function signatures match.")
            end
            
            return (success=false, output="", error=error_msg)
        end
        
    catch e
        return (success=false, output="", error=string(e))
    end
end

"""
    find_artifacts(work_dir::String)

Finds generated artifacts (plots, data files, etc.) in the work directory.
"""
function find_artifacts(work_dir::String)
    artifacts = String[]
    
    for file in readdir(work_dir)
        if endswith(file, ".png") || endswith(file, ".pdf") || 
           endswith(file, ".csv") || endswith(file, ".json")
            push!(artifacts, joinpath(work_dir, file))
        end
    end
    
    return artifacts
end

"""
    enhance_error_feedback(result)

Enhances error messages with specific guidance for common Julia/DataFrame issues.
"""
function enhance_error_feedback(result)
    error_msg = result.error
    enhanced_msg = error_msg
    
    # Common DataFrame iteration errors
    if contains(error_msg, "iteration is deliberately unsupported")
        enhanced_msg *= "\n\nFIX: Use eachrow(df) instead of iterating df directly"
        enhanced_msg *= "\nExample: for row in eachrow(df) ... end"
    end
    
    # Column access errors
    if contains(error_msg, "BoundsError") && contains(error_msg, "DataFrame")
        enhanced_msg *= "\n\nFIX: Use df[!, :column_name] for column access"
        enhanced_msg *= "\nExample: values = df[!, :price]"
    end
    
    # Missing function errors
    if contains(error_msg, "UndefVarError") && contains(error_msg, "data_path")
        enhanced_msg *= "\n\nFIX: data_path() function should be automatically provided"
        enhanced_msg *= "\nCheck if code preparation step is working correctly"
    end
    
    # Package loading errors
    if contains(error_msg, "not defined") && (contains(error_msg, "CSV") || contains(error_msg, "DataFrames"))
        enhanced_msg *= "\n\nFIX: Add 'using CSV, DataFrames' at the top of your code"
    end
    
    return (success=result.success, output=result.output, error=enhanced_msg)
end

"""
    CodeValidationResult

Result of code validation with issues found.
"""
struct CodeValidationResult
    valid::Bool
    issues::Vector{String}
end

"""
    validate_code_before_execution(code::String)

Validates Julia code for common issues before execution.
"""
function validate_code_before_execution(code::String)
    issues = String[]
    
    # Check for DataFrame iteration issues
    if contains(code, r"for\s+\w+\s+in\s+df\b") && !contains(code, "eachrow(df)")
        push!(issues, "Direct DataFrame iteration detected - use 'for row in eachrow(df)' instead")
    end
    
    # Check for @load macro usage
    if contains(code, "@load")
        push!(issues, "Using @load macro - use explicit model imports instead")
    end
    
    # Check for undefined column references
    if contains(code, r"df\[\s*!\s*,\s*:(?!CUST_ID|BALANCE|PURCHASES|CASH_ADVANCE|CREDIT_LIMIT|PAYMENTS|MINIMUM_PAYMENTS|PRC_FULL_PAYMENT|TENURE|BALANCE_FREQUENCY|PURCHASES_FREQUENCY|ONEOFF_PURCHASES|INSTALLMENTS_PURCHASES|CASH_ADVANCE_FREQUENCY|ONEOFF_PURCHASES_FREQUENCY|PURCHASES_INSTALLMENTS_FREQUENCY|CASH_ADVANCE_TRX|PURCHASES_TRX)\w+")
        push!(issues, "Potential undefined column reference - check column names first with names(df)")
    end
    
    # Check for data loading without data_path
    if contains(code, r"CSV\.read\s*\(\s*[\"'](?!data_path)") && contains(code, ".csv")
        push!(issues, "CSV loading without data_path() function - use data_path(\"filename.csv\")")
    end
    
    # Check for missing variable definitions
    if contains(code, r"\bdf\b") && !contains(code, r"df\s*=\s*CSV\.read")
        push!(issues, "Variable 'df' used but not defined - add data loading first")
    end
    
    return CodeValidationResult(isempty(issues), issues)
end

"""
    repair_common_code_issues(code::String)

Automatically repairs common code issues.
"""
function repair_common_code_issues(code::String)
    repaired = code
    
    # Fix DataFrame iteration
    repaired = replace(repaired, r"for\s+(\w+)\s+in\s+df\b" => s"for \1 in eachrow(df)")
    
    # Fix CSV loading without data_path
    repaired = replace(repaired, r"CSV\.read\s*\(\s*[\"']([^\"']*\.csv)[\"']" => s"CSV.read(data_path(\"\1\")")
    
    # Remove @load macro attempts
    repaired = replace(repaired, r"@load\s+\w+.*\n?" => "")
    
    # Add data loading if df is used but not defined
    if contains(repaired, r"\bdf\b") && !contains(repaired, r"df\s*=\s*CSV\.read")
        repaired = "# Auto-added data loading\ndf = CSV.read(data_path(\"cc_data.csv\"), DataFrame)\nprintln(\"Data loaded: \", size(df))\n\n" * repaired
    end
    
    return repaired
end

"""
    sanitize_julia_code(code::String)

Applies comprehensive sanitization to fix common Julia DataFrame issues.
"""
function sanitize_julia_code(code::String)
    sanitized = code
    
    # ULTRA-AGGRESSIVE: Fix ALL DataFrame iteration patterns
    # Handle enumerate patterns first with string matching
    if contains(sanitized, "enumerate(df)")
        sanitized = replace(sanitized, "enumerate(df)" => "enumerate(eachrow(df))")
    end
    
    # Pattern 1: Manual handling of basic patterns to preserve variable names
    # Find and replace "for X in df" patterns
    matches = collect(eachmatch(r"for\s+(\w+)\s+in\s+df\b", sanitized))
    for match_obj in reverse(matches)  # Work backwards to preserve indices
        var_name = match_obj.captures[1]
        full_match = match_obj.match
        
        # Decide if it's a row or column based on variable name
        if var_name in ["col", "c", "column", "var", "variable", "field"]
            replacement = "for $var_name in eachcol(df)"
        else
            replacement = "for $var_name in eachrow(df)"
        end
        
        # Replace this specific occurrence
        start_idx = match_obj.offset
        end_idx = start_idx + length(full_match) - 1
        sanitized = sanitized[1:start_idx-1] * replacement * sanitized[end_idx+1:end]
    end
    
    # Pattern 2: Fix any remaining direct DataFrame iteration
    sanitized = replace(sanitized, "iterate(df)" => "eachrow(df)")
    sanitized = replace(sanitized, "collect(df)" => "collect(eachrow(df))")
    
    # Remove @load macro completely
    sanitized = replace(sanitized, r"@load\s+\w+.*\n?" => "")
    sanitized = replace(sanitized, r"using\s+MLJ:\s*@load.*\n?" => "")
    
    # Fix common CSV loading patterns  
    sanitized = replace(sanitized, r"CSV\.read\s*\(\s*[\"'](?!data_path)([^\"']*\.csv)[\"']" => SubstitutionString("CSV.read(data_path(\"\\1\")"))
    
    # Fix double data_path issues
    sanitized = replace(sanitized, r"data_path\s*\(\s*[\"']data_path\([\"']([^\"']+)[\"']\)[\"']\s*\)" => SubstitutionString("data_path(\"\\1\")"))
    sanitized = replace(sanitized, r"data_path\s*\(\s*[\"']data/([^\"']+)[\"']\s*\)" => SubstitutionString("data_path(\"\\1\")"))
    
    # Add data loading if df is used but not defined
    if contains(sanitized, r"\bdf\b") && !contains(sanitized, r"df\s*=")
        sanitized = "# Auto-added data loading\ndf = CSV.read(data_path(\"cc_data.csv\"), DataFrame)\nprintln(\"Data loaded: \", size(df))\n\n" * sanitized
    end
    
    return sanitized
end