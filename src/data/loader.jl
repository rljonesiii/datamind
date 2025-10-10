"""
    DataLoader

Handles loading and initial examination of various data formats.
"""
module DataLoader

using CSV, DataFrames, Statistics

"""
    load_csv(filepath::String)

Loads a CSV file and returns basic information about the dataset.
"""
function load_csv(filepath::String)
    if !isfile(filepath)
        throw(ArgumentError("File not found: $filepath"))
    end
    
    try
        # Load the CSV
        df = CSV.read(filepath, DataFrame)
        
        # Generate basic info
        info = Dict{String, Any}(
            "filepath" => filepath,
            "shape" => (nrow(df), ncol(df)),
            "columns" => names(df),
            "column_types" => [eltype(df[!, col]) for col in names(df)],
            "missing_counts" => [count(ismissing, df[!, col]) for col in names(df)],
            "sample_data" => first(df, min(5, nrow(df)))
        )
        
        # Add numeric column statistics
        numeric_cols = [col for col in names(df) if eltype(df[!, col]) <: Number]
        if !isempty(numeric_cols)
            info["numeric_summary"] = Dict(
                col => Dict(
                    "mean" => mean(skipmissing(df[!, col])),
                    "std" => std(skipmissing(df[!, col])),
                    "min" => minimum(skipmissing(df[!, col])),
                    "max" => maximum(skipmissing(df[!, col]))
                ) for col in numeric_cols
            )
        end
        
        # Add categorical column info
        categorical_cols = [col for col in names(df) if !(eltype(df[!, col]) <: Number)]
        if !isempty(categorical_cols)
            info["categorical_summary"] = Dict()
            for col in categorical_cols
                if col != "sample_data"  # Skip the sample_data field
                    try
                        unique_vals = unique(skipmissing(df[!, col]))
                        info["categorical_summary"][col] = Dict(
                            "unique_count" => length(unique_vals),
                            "most_common" => try
                                counts = countmap(skipmissing(df[!, col]))
                                first(sort(collect(counts), by=x->x[2], rev=true), min(3, length(counts)))
                            catch
                                []
                            end
                        )
                    catch
                        info["categorical_summary"][col] = Dict(
                            "unique_count" => 0,
                            "most_common" => []
                        )
                    end
                end
            end
        end
        
        return df, info
        
    catch e
        throw(ArgumentError("Error loading CSV file: $e"))
    end
end

"""
    generate_data_summary(info::Dict)

Generates a human-readable summary of the dataset.
"""
function generate_data_summary(info::Dict)
    summary_parts = String[]
    
    push!(summary_parts, "📊 Dataset Summary:")
    push!(summary_parts, "Shape: $(info["shape"][1]) rows × $(info["shape"][2]) columns")
    push!(summary_parts, "")
    
    push!(summary_parts, "📋 Columns:")
    for (i, col) in enumerate(info["columns"])
        missing_count = info["missing_counts"][i]
        missing_pct = round(missing_count / info["shape"][1] * 100, digits=1)
        push!(summary_parts, "  • $col ($(info["column_types"][i])) - $missing_count missing ($missing_pct%)")
    end
    
    if haskey(info, "numeric_summary")
        push!(summary_parts, "")
        push!(summary_parts, "🔢 Numeric Columns Summary:")
        for (col, stats) in info["numeric_summary"]
            push!(summary_parts, "  • $col: mean=$(round(stats["mean"], digits=2)), std=$(round(stats["std"], digits=2))")
        end
    end
    
    if haskey(info, "categorical_summary")
        push!(summary_parts, "")
        push!(summary_parts, "📝 Categorical Columns Summary:")
        for (col, stats) in info["categorical_summary"]
            push!(summary_parts, "  • $col: $(stats["unique_count"]) unique values")
        end
    end
    
    return join(summary_parts, "\n")
end

"""
    countmap(x)

Simple implementation of countmap for counting occurrences.
"""
function countmap(x)
    counts = Dict()
    for item in x
        counts[item] = get(counts, item, 0) + 1
    end
    return counts
end

end # module DataLoader