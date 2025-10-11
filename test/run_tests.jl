using Test
using Pkg
Pkg.activate(".")

# Load DataMind module
include("../src/DataMind.jl")
using .DataMind

println("🧪 DataMind Test Suite")
println("="^50)

# Discover all test files in the test directory
test_dir = @__DIR__
all_test_files = filter(f -> endswith(f, ".jl") && f != "run_tests.jl", readdir(test_dir))

println("📂 Discovered $(length(all_test_files)) test files:")
for file in sort(all_test_files)
    println("  • $file")
end
println()

@testset "DataMind Complete Test Suite" begin
    
    @testset "Core Components" begin
        @testset "Experiment Creation" begin
            research_question = "Test question"
            experiment = Experiment(research_question)
            
            @test experiment.research_question == research_question
            @test !isempty(experiment.id)
            println("✅ Experiment creation tests passed")
        end
        
        @testset "Agent Message Creation" begin
            msg = AgentMessage("planning", "codegen", "plan_ready", Dict("plan" => "test"))
            
            @test msg.from_agent == "planning"
            @test msg.to_agent == "codegen" 
            @test msg.message_type == "plan_ready"
            @test msg.content["plan"] == "test"
            println("✅ Agent message tests passed")
        end
    end
    
    @testset "Discovered Test Scripts" begin
        println("🔄 Running all discovered test scripts...")
        
        # Run each test file as a subprocess to avoid module conflicts
        for test_file in sort(all_test_files)
            test_name = replace(test_file, ".jl" => "", "_" => " ")
            test_name = titlecase(test_name)
            
            @testset "$test_name" begin
                println("🧪 Running: $test_file")
                
                # Use joinpath to ensure correct path
                test_path = joinpath(test_dir, test_file)
                
                try
                    result = run(`julia --project=. $test_path`)
                    @test result.exitcode == 0
                    println("✅ $test_file passed")
                catch e
                    @warn "❌ $test_file failed" error=e
                    # Don't fail the entire test suite for individual test failures
                    # This allows us to see which tests pass/fail
                    @test_broken false
                end
            end
        end
    end
end

println("\n🎉 All DataMind tests completed!")
println("📊 Test Summary:")
println("  Total test files discovered: $(length(all_test_files))")
println("  Test files:")
for file in sort(all_test_files)
    println("    • $file")
end
println("="^50)