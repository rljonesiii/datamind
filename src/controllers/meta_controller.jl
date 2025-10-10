"""
    MetaController

Orchestrates the experiment cycle: plan → code → execute → evaluate → reflect.
Maintains global state and coordinates between specialized agents.
"""
mutable struct MetaController
    experiment::Experiment
    agents::Dict{String, Any}
    knowledge_graph::KnowledgeGraph
    config::Dict{String, Any}
    message_bus::Vector{AgentMessage}
    
    function MetaController(experiment::Experiment, config::Dict)
        controller = new()
        controller.experiment = experiment
        controller.agents = Dict{String, Any}()
        controller.knowledge_graph = KnowledgeGraph()
        controller.config = config
        controller.message_bus = Vector{AgentMessage}()
        
        # Initialize agents
        controller.agents["planning"] = PlanningAgent(config["agents"]["planning"])
        controller.agents["codegen"] = CodeGenAgent(config["agents"]["codegen"])
        controller.agents["evaluation"] = EvaluationAgent(config["agents"]["evaluation"])
        
        return controller
    end
end

"""
    run_experiment_cycle(controller::MetaController, max_iterations::Int=10)

Executes the main experiment loop until completion or max iterations.
"""
function run_experiment_cycle(controller::MetaController, max_iterations::Int=10)
    results = Vector{ExperimentResult}()
    
    for iteration in 1:max_iterations
        println("🔄 Starting iteration $iteration")
        
        try
            # Planning phase
            controller.experiment.state = PLANNING
            println("  📋 Planning phase...")
            plan = generate_plan(controller.agents["planning"], controller.experiment)
            
            # Code generation phase  
            controller.experiment.state = CODING
            println("  💻 Code generation phase...")
            code = generate_code(controller.agents["codegen"], plan, controller.experiment)
            
            # Execution phase
            controller.experiment.state = EXECUTING
            println("  ⚡ Execution phase...")
            sandbox = ExecutionSandbox(controller.config["execution"])
            execution_result = execute_code(sandbox, code)
            
            # Evaluation phase
            controller.experiment.state = EVALUATING
            println("  📊 Evaluation phase...")
            evaluation = evaluate_results(controller.agents["evaluation"], execution_result, controller.experiment)
            
            # Create result
            result = ExperimentResult(
                evaluation.success,
                evaluation.metrics,
                execution_result.artifacts,
                code,
                execution_result.output,
                evaluation.summary,
                evaluation.next_actions
            )
            
            push!(results, result)
            
            # Update knowledge graph
            update_knowledge(controller.knowledge_graph, controller.experiment, result)
            
            # Check if experiment is complete
            if evaluation.success && evaluation.confidence > 0.8
                controller.experiment.state = COMPLETED
                println("✅ Experiment completed successfully!")
                break
            elseif evaluation.should_stop
                controller.experiment.state = FAILED
                println("❌ Experiment stopped due to repeated failures")
                break
            end
            
            # Reflection phase - update experiment context
            controller.experiment.state = REFLECTING
            println("  🤔 Reflection phase...")
            update_experiment_context!(controller.experiment, result)
            
            # Add small delay to prevent overwhelming the system
            sleep(0.1)
            
        catch e
            println("❌ Error in iteration $iteration: $e")
            controller.experiment.state = FAILED
            break
        end
    end
    
    return results
end

"""
    update_experiment_context!(experiment::Experiment, result::ExperimentResult)

Updates experiment context with learnings from the latest iteration.
"""
function update_experiment_context!(experiment::Experiment, result::ExperimentResult)
    # Add result to history
    push!(experiment.history, Dict(
        "iteration" => length(experiment.history) + 1,
        "success" => result.success,
        "metrics" => result.metrics,
        "code" => result.code_generated,
        "timestamp" => Dates.now()
    ))
    
    # Update context with key learnings
    if result.success
        experiment.context["successful_patterns"] = get(experiment.context, "successful_patterns", String[])
        push!(experiment.context["successful_patterns"], extract_pattern(result.code_generated))
    end
    
    experiment.context["last_metrics"] = result.metrics
    experiment.context["iteration_count"] = length(experiment.history)
end

"""
    extract_pattern(code::String)

Extracts reusable patterns from successful code for future reference.
"""
function extract_pattern(code::String)
    # Simple pattern extraction - could be enhanced with AST parsing
    lines = split(code, "\n")
    imports = filter(line -> startswith(strip(line), "import") || startswith(strip(line), "using"), lines)
    return join(imports, "\n")
end