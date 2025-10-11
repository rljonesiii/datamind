"""
Environment Utilities

Centralized utilities for loading environment variables from .env files.
"""

"""
    load_env_file(filepath=".env")

Loads environment variables from a .env file. Looks for the file in the current
working directory by default, or at the specified filepath.

# Arguments
- `filepath::String`: Path to the .env file (default: ".env")

# Example
```julia
load_env_file()  # Load from .env in current directory
load_env_file("config/.env")  # Load from specific path
```
"""
function load_env_file(filepath=".env")
    if isfile(filepath)
        for line in readlines(filepath)
            line = strip(line)
            if !isempty(line) && !startswith(line, "#") && contains(line, "=")
                key, value = split(line, "=", limit=2)
                ENV[strip(key)] = strip(value)
            end
        end
        @info "✅ Loaded environment variables from .env file at $filepath"
    else
        @warn "⚠️  No .env file found at $filepath - using system environment variables"
    end
end

export load_env_file