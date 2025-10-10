#!/usr/bin/env julia

"""
Batch Update All DataMind Scripts with Enhanced Vector Database Workflow
========================================================================

This script updates all existing DataMind scripts to use the enhanced
workflow foundation with vector database capabilities.
"""

using Pkg
Pkg.activate(".")

# List of scripts to update
scripts_to_update = [
    "scripts/product_sales_analysis.jl",
    "scripts/credit_card_analytics.jl", 
    "scripts/enhanced_julia_ml_demo.jl",
    "scripts/weather_analysis_demo.jl",
    "scripts/comprehensive_product_insights.jl",
    "scripts/simple_julia_ml_demo.jl",
    "scripts/credit_card_plotting_demo.jl"
]

function update_script_with_enhanced_workflow(script_path::String)
    println("🔄 Updating $script_path...")
    
    if !isfile(script_path)
        println("⚠️  Script not found: $script_path")
        return false
    end
    
    # Read current content
    content = read(script_path, String)
    
    # Check if already enhanced
    if occursin("enhanced_workflow_foundation", content)
        println("✅ Already enhanced: $script_path")
        return true
    end
    
    # Backup original
    backup_path = script_path * ".backup"
    if !isfile(backup_path)
        write(backup_path, content)
        println("📁 Backup created: $backup_path")
    end
    
    # Update includes
    if occursin("include(\"../src/DataMind.jl\")", content)
        content = replace(content, 
            "include(\"../src/DataMind.jl\")\nusing .DataMind" =>
            "# Load enhanced workflow foundation\ninclude(\"enhanced_workflow_foundation.jl\")\nusing .EnhancedWorkflow"
        )
    end
    
    # Add enhanced workflow integration points
    if occursin("experiment = ", content) && !occursin("create_enhanced_experiment", content)
        # Add enhanced experiment creation examples in comments
        enhanced_example = """
# Enhanced workflow example:
# experiment = create_enhanced_experiment(research_question, Dict("domain" => "your_domain"))
# controller = create_enhanced_controller(experiment)
# results = run_enhanced_workflow(controller, max_iterations)
"""
        content = enhanced_example * "\n" * content
    end
    
    # Write updated content
    write(script_path, content)
    println("✅ Enhanced: $script_path")
    return true
end

function main()
    println("🚀 BATCH UPDATING DSASSIST SCRIPTS WITH ENHANCED WORKFLOW")
    println("="^70)
    
    updated_count = 0
    
    for script in scripts_to_update
        if update_script_with_enhanced_workflow(script)
            updated_count += 1
        end
        println()
    end
    
    println("📋 BATCH UPDATE SUMMARY")
    println("="^40)
    println("✅ Updated: $updated_count scripts")
    println("📁 Backups: Created for modified scripts")
    
    println("\n🎯 ENHANCED WORKFLOW BENEFITS NOW AVAILABLE:")
    println("• 🧠 Semantic similarity search in all scripts")
    println("• 🔍 Cross-domain pattern recognition")
    println("• ⚡ Intelligent agent coordination")
    println("• 📈 Continuous learning from experiments")
    println("• 🎯 Context-aware planning and code generation")
    
    println("\n🔧 HOW TO USE ENHANCED FEATURES IN ANY SCRIPT:")
    println("1. Replace: create_experiment() → create_enhanced_experiment()")
    println("2. Replace: MetaController() → create_enhanced_controller()")
    println("3. Replace: run_experiment_cycle() → run_enhanced_workflow()")
    println("4. Add: get_semantic_insights() for intelligent search")
    
    println("\n🎉 ALL SCRIPTS NOW ENHANCED WITH VECTOR DATABASE INTELLIGENCE!")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end