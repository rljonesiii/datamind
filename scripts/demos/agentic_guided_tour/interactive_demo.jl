### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ Cell order:
# ╠═first_cell
# ╠═import_cell  
# ╠═experiment_cell
# ╠═results_cell

# ╔═╡ first_cell ╠═╡
md"""
# DSAssist Interactive Demo

This notebook demonstrates the DSAssist agentic data science workflow system.
"""

# ╔═╡ import_cell ╠═╡
begin
    using Pkg
    
    # Get project root and activate
    notebook_dir = @__DIR__
    project_root = joinpath(notebook_dir, "..", "..", "..")
    Pkg.activate(project_root)
    
    include(joinpath(project_root, "src", "DataMind.jl"))
    using .DataMind
    using PlutoUI
end

# ╔═╡ experiment_cell ╠═╡
begin
    # Create an interactive experiment
    research_question = @bind question TextField(default="What factors influence customer satisfaction?")
    
    md"""
    **Research Question:** $research_question
    
    Click the button below to start autonomous exploration:
    """
end

# ╔═╡ results_cell ╠═╡
begin
    if @isdefined question && !isempty(strip(question))
        experiment = create_experiment(question)
        
        md"""
        **Experiment Created:** $(experiment.id)
        
        **Status:** Ready to run autonomous exploration
        
        *Note: In a full implementation, this would run the actual agent cycle*
        """
    else
        md"*Enter a research question above to begin*"
    end
end