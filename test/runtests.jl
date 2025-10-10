using Test
using DSAssist

@testset "DSAssist Core Tests" begin
    
    @testset "Experiment Creation" begin
        research_question = "Test question"
        experiment = Experiment(research_question)
        
        @test experiment.research_question == research_question
        @test experiment.state == PLANNING
        @test isempty(experiment.history)
        @test !isempty(experiment.id)
    end
    
    @testset "Agent Message Creation" begin
        msg = AgentMessage("planning", "codegen", "plan_ready", Dict("plan" => "test"))
        
        @test msg.from_agent == "planning"
        @test msg.to_agent == "codegen"
        @test msg.message_type == "plan_ready"
        @test msg.content["plan"] == "test"
    end
    
    @testset "Mock LLM Client" begin
        config = AgentConfig("test", "mock", 0.3, 100, "test prompt", 3)
        client = LLMClient(config)
        
        # Test mock responses
        planning_response = call_llm(client, "test planning prompt")
        @test contains(planning_response, "hypothesis")
        
        codegen_response = call_llm(client, "test codegen prompt")  
        @test contains(codegen_response, "using")
        
        eval_response = call_llm(client, "test evaluation prompt")
        @test contains(eval_response, "success")
    end
    
    @testset "Knowledge Graph Operations" begin
        kg = KnowledgeGraph()
        experiment = Experiment("Test question")
        
        result = ExperimentResult(
            true,
            Dict("accuracy" => 0.85),
            String[],
            "test code",
            "test output", 
            "test summary",
            String[]
        )
        
        update_knowledge(kg, experiment, result)
        
        @test haskey(kg.experiments, experiment.id)
        @test kg.experiments[experiment.id]["research_question"] == "Test question"
    end
    
    @testset "Pattern Extraction" begin
        code = """
        using DataFrames, Statistics
        df = DataFrame(x = [1,2,3])
        mean_val = mean(df.x)
        """
        
        pattern = extract_imports_and_key_lines(code)
        @test contains(pattern, "using DataFrames")
        @test contains(pattern, "mean(df.x)")
    end
end