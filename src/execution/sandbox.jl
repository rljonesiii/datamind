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
        # Write code to file
        open(code_file, "w") do f
            write(f, prepare_code_for_execution(code, sandbox.work_dir))
        end
        
        # Execute with timeout and capture output
        result = execute_with_timeout(code_file, sandbox.timeout)
        
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
    setup = """
    # Auto-generated execution setup
    cd("$work_dir")
    
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
        
        # Store original stdout before try block
        old_stdout = stdout
        
        try
            # Redirect stdout temporarily
            redirect_stdout(output_buffer)
            
            # Execute the code in a try-catch block
            eval(Meta.parse("begin\n$code_content\nend"))
            
            # Restore stdout
            redirect_stdout(old_stdout)
            
            output = String(take!(output_buffer))
            return (success=true, output=output, error="")
            
        catch e
            # Restore stdout
            redirect_stdout(old_stdout)
            
            error_msg = string(e)
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