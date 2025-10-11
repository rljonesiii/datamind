#!/usr/bin/env julia

"""
DataMind Direct Analysis CLI

Quick access to direct LLM-powered data analysis without the full agentic workflow.
Ideal for rapid insights and exploratory analysis.

Usage:
    julia scripts/direct_analysis.jl "Research question here"
    
Example:
    julia scripts/direct_analysis.jl "What are the key sales trends in my data?"
"""

# Run the direct analysis interface
include("../src/interfaces/direct_analysis.jl")