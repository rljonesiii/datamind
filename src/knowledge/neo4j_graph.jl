"""
    Neo4jKnowledgeGraph

Neo4j-powered knowledge graph implementation for DataMind.
Maintains experiment provenance and learning history in a Neo4j database.
"""

using HTTP, JSON3
import Dates
import Base64: base64encode

struct Neo4jKnowledgeGraph
    uri::String
    user::String
    password::String
    
    function Neo4jKnowledgeGraph(uri::String, user::String, password::String)
        new(uri, user, password)
    end
end

"""
Create Neo4j knowledge graph from environment variables
"""
function create_neo4j_knowledge_graph()
    # Convert bolt URI to HTTP URI if needed
    uri = get(ENV, "NEO4J_URI", "bolt://localhost:7687")
    if startswith(uri, "bolt://")
        # Convert bolt://localhost:7687 to http://localhost:7474
        uri = replace(uri, "bolt://" => "http://", ":7687" => ":7474")
    end
    
    user = get(ENV, "NEO4J_USER", "neo4j")
    password = get(ENV, "NEO4J_PASSWORD", "")
    
    if isempty(password)
        @warn "NEO4J_PASSWORD not set, falling back to in-memory knowledge graph"
        return nothing
    end
    
    return Neo4jKnowledgeGraph(uri, user, password)
end

"""
Execute a Cypher query via Neo4j HTTP API
"""
function execute_cypher(kg::Neo4jKnowledgeGraph, query::String, parameters::Dict{String, Any}=Dict{String, Any}())
    # Convert bolt:// to http:// for HTTP API
    http_uri = replace(kg.uri, "bolt://" => "http://")
    if !endswith(http_uri, "/")
        http_uri *= "/"
    end
    endpoint = http_uri * "db/neo4j/tx/commit"
    
    # Prepare request
    auth_header = "Basic " * base64encode("$(kg.user):$(kg.password)")
    headers = [
        "Authorization" => auth_header,
        "Content-Type" => "application/json",
        "Accept" => "application/json"
    ]
    
    body = JSON3.write(Dict(
        "statements" => [Dict(
            "statement" => query,
            "parameters" => parameters
        )]
    ))
    
    try
        response = HTTP.post(endpoint, headers, body)
        result = JSON3.read(String(response.body))
        
        if haskey(result, "errors") && !isempty(result.errors)
            error_msg = join([err.message for err in result.errors], "; ")
            throw(ArgumentError("Neo4j query failed: $error_msg"))
        end
        
        return result
    catch e
        @error "Failed to execute Neo4j query" query=query error=e
        throw(e)
    end
end

"""
Initialize the knowledge graph schema with comprehensive advanced ontology including ensemble intelligence
"""
function initialize_schema(kg::Neo4jKnowledgeGraph)
    # Create constraints and indexes for all node types
    schema_queries = [
        # Core experiment constraints
        "CREATE CONSTRAINT datamind_experiment_id IF NOT EXISTS FOR (e:DataMindExperiment) REQUIRE e.id IS UNIQUE",
        "CREATE CONSTRAINT datamind_iteration_id IF NOT EXISTS FOR (i:DataMindIteration) REQUIRE (i.experiment_id, i.iteration) IS UNIQUE",
        
        # Knowledge artifact constraints
        "CREATE CONSTRAINT datamind_pattern_id IF NOT EXISTS FOR (p:CodePattern) REQUIRE p.id IS UNIQUE",
        "CREATE CONSTRAINT datamind_technique_name IF NOT EXISTS FOR (t:Technique) REQUIRE t.name IS UNIQUE",
        "CREATE CONSTRAINT datamind_domain_name IF NOT EXISTS FOR (d:Domain) REQUIRE d.name IS UNIQUE",
        
        # Cognitive & Learning Intelligence constraints
        "CREATE CONSTRAINT agent_name IF NOT EXISTS FOR (a:Agent) REQUIRE a.name IS UNIQUE",
        "CREATE CONSTRAINT strategy_id IF NOT EXISTS FOR (s:Strategy) REQUIRE s.id IS UNIQUE",
        "CREATE CONSTRAINT decision_rule_id IF NOT EXISTS FOR (dr:DecisionRule) REQUIRE dr.id IS UNIQUE",
        "CREATE CONSTRAINT learning_pattern_id IF NOT EXISTS FOR (lp:LearningPattern) REQUIRE lp.id IS UNIQUE",
        "CREATE CONSTRAINT knowledge_state_id IF NOT EXISTS FOR (ks:KnowledgeState) REQUIRE ks.id IS UNIQUE",
        
        # Temporal & Contextual Intelligence constraints
        "CREATE CONSTRAINT time_context_id IF NOT EXISTS FOR (tc:TimeContext) REQUIRE tc.id IS UNIQUE",
        "CREATE CONSTRAINT experiment_context_id IF NOT EXISTS FOR (ec:ExperimentContext) REQUIRE ec.id IS UNIQUE",
        "CREATE CONSTRAINT environment_snapshot_id IF NOT EXISTS FOR (es:EnvironmentSnapshot) REQUIRE es.id IS UNIQUE",
        
        # Causal & Explanatory Intelligence constraints
        "CREATE CONSTRAINT causal_factor_id IF NOT EXISTS FOR (cf:CausalFactor) REQUIRE cf.id IS UNIQUE",
        "CREATE CONSTRAINT explanation_id IF NOT EXISTS FOR (e:Explanation) REQUIRE e.id IS UNIQUE",
        "CREATE CONSTRAINT assumption_id IF NOT EXISTS FOR (a:Assumption) REQUIRE a.id IS UNIQUE",
        
        # Risk & Reliability Intelligence constraints
        "CREATE CONSTRAINT risk_factor_id IF NOT EXISTS FOR (rf:RiskFactor) REQUIRE rf.id IS UNIQUE",
        "CREATE CONSTRAINT failure_mode_id IF NOT EXISTS FOR (fm:FailureMode) REQUIRE fm.id IS UNIQUE",
        "CREATE CONSTRAINT validation_rule_id IF NOT EXISTS FOR (vr:ValidationRule) REQUIRE vr.id IS UNIQUE",
        
        # Data & Feature Intelligence constraints
        "CREATE CONSTRAINT data_source_id IF NOT EXISTS FOR (ds:DataSource) REQUIRE ds.id IS UNIQUE",
        "CREATE CONSTRAINT feature_transform_id IF NOT EXISTS FOR (ft:FeatureTransform) REQUIRE ft.id IS UNIQUE",
        "CREATE CONSTRAINT feature_interaction_id IF NOT EXISTS FOR (fi:FeatureInteraction) REQUIRE fi.id IS UNIQUE",
        
        # Ensemble Methods Intelligence constraints
        "CREATE CONSTRAINT ensemble_method_id IF NOT EXISTS FOR (em:EnsembleMethod) REQUIRE em.id IS UNIQUE",
        "CREATE CONSTRAINT base_model_id IF NOT EXISTS FOR (bm:BaseModel) REQUIRE bm.id IS UNIQUE",
        "CREATE CONSTRAINT meta_learner_id IF NOT EXISTS FOR (ml:MetaLearner) REQUIRE ml.id IS UNIQUE",
        "CREATE CONSTRAINT stacking_level_id IF NOT EXISTS FOR (sl:StackingLevel) REQUIRE sl.id IS UNIQUE",
        "CREATE CONSTRAINT bootstrap_strategy_id IF NOT EXISTS FOR (bs:BootstrapStrategy) REQUIRE bs.id IS UNIQUE",
        "CREATE CONSTRAINT boosting_sequence_id IF NOT EXISTS FOR (bs:BoostingSequence) REQUIRE bs.id IS UNIQUE",
        "CREATE CONSTRAINT weak_learner_id IF NOT EXISTS FOR (wl:WeakLearner) REQUIRE wl.id IS UNIQUE",
        "CREATE CONSTRAINT bayesian_prior_id IF NOT EXISTS FOR (bp:BayesianPrior) REQUIRE bp.id IS UNIQUE",
        "CREATE CONSTRAINT model_posterior_id IF NOT EXISTS FOR (mp:ModelPosterior) REQUIRE mp.id IS UNIQUE",
        "CREATE CONSTRAINT nonparametric_process_id IF NOT EXISTS FOR (np:NonparametricProcess) REQUIRE np.id IS UNIQUE",
        
        # Performance indexes
        "CREATE INDEX datamind_experiment_question IF NOT EXISTS FOR (e:DataMindExperiment) ON (e.research_question)",
        "CREATE INDEX datamind_iteration_success IF NOT EXISTS FOR (i:DataMindIteration) ON (i.success)",
        "CREATE INDEX datamind_experiment_created IF NOT EXISTS FOR (e:DataMindExperiment) ON (e.created_at)",
        "CREATE INDEX datamind_experiment_domain IF NOT EXISTS FOR (e:DataMindExperiment) ON (e.domain_tags)",
        "CREATE INDEX datamind_technique_category IF NOT EXISTS FOR (t:Technique) ON (t.category)",
        "CREATE INDEX datamind_pattern_category IF NOT EXISTS FOR (p:CodePattern) ON (p.category)",
        
        # Advanced intelligence indexes for performance optimization
        "CREATE INDEX agent_expertise IF NOT EXISTS FOR (a:Agent) ON (a.expertise_level)",
        "CREATE INDEX strategy_success_rate IF NOT EXISTS FOR (s:Strategy) ON (s.success_rate)",
        "CREATE INDEX risk_probability IF NOT EXISTS FOR (rf:RiskFactor) ON (rf.probability)",
        "CREATE INDEX ensemble_performance IF NOT EXISTS FOR (em:EnsembleMethod) ON (em.performance_improvement)",
        "CREATE INDEX base_model_contribution IF NOT EXISTS FOR (bm:BaseModel) ON (bm.ensemble_contribution)",
        "CREATE INDEX time_context_period IF NOT EXISTS FOR (tc:TimeContext) ON (tc.period)",
        "CREATE INDEX experiment_context_resources IF NOT EXISTS FOR (ec:ExperimentContext) ON (ec.computing_resources)",
        "CREATE INDEX failure_mode_severity IF NOT EXISTS FOR (fm:FailureMode) ON (fm.severity)",
        "CREATE INDEX causal_factor_strength IF NOT EXISTS FOR (cf:CausalFactor) ON (cf.strength)"
    ]
    
    for query in schema_queries
        try
            execute_cypher(kg, query)
        catch e
            @warn "Schema query may have failed (this is often ok for existing constraints)" query=query error=e
        end
    end
    
    @info "Neo4j schema initialized"
end

"""
Update the knowledge graph with new experiment results and create rich relationships
"""
function update_knowledge(kg::Neo4jKnowledgeGraph, experiment::Experiment, result::ExperimentResult)
    iteration = length(experiment.history) + 1
    
    # Extract domain tags from research question
    domain_tags = extract_domain_tags(experiment.research_question)
    techniques = extract_techniques(result.code_generated, result.evaluation_summary)
    
    # Create or update experiment node with enhanced metadata
    experiment_query = """
    MERGE (exp:DataMindExperiment {id: \$experiment_id})
    SET exp.research_question = \$research_question,
        exp.created_at = \$created_at,
        exp.updated_at = datetime(),
        exp.status = \$status,
        exp.domain_tags = \$domain_tags,
        exp.complexity_score = \$complexity_score
    RETURN exp.id as id
    """
    
    experiment_params = Dict{String, Any}(
        "experiment_id" => experiment.id,
        "research_question" => experiment.research_question,
        "created_at" => string(experiment.created_at),
        "status" => string(experiment.state),
        "domain_tags" => domain_tags,
        "complexity_score" => estimate_complexity(experiment.research_question)
    )
    
    execute_cypher(kg, experiment_query, experiment_params)
    
    # Create iteration node with enhanced metadata
    iteration_query = """
    MATCH (exp:DataMindExperiment {id: \$experiment_id})
    MERGE (iter:DataMindIteration {experiment_id: \$experiment_id, iteration: \$iteration})
    SET iter.success = \$success,
        iter.metrics = \$metrics,
        iter.code_generated = \$code_generated,
        iter.artifacts = \$artifacts,
        iter.evaluation_summary = \$evaluation_summary,
        iter.execution_output = \$execution_output,
        iter.next_actions = \$next_actions,
        iter.techniques_used = \$techniques_used,
        iter.timestamp = datetime()
    MERGE (exp)-[:HAS_ITERATION]->(iter)
    RETURN iter.iteration as iteration
    """
    
    iteration_params = Dict{String, Any}(
        "experiment_id" => experiment.id,
        "iteration" => iteration,
        "success" => result.success,
        "metrics" => JSON3.write(result.metrics),
        "code_generated" => result.code_generated,
        "artifacts" => JSON3.write(result.artifacts),
        "evaluation_summary" => result.evaluation_summary,
        "execution_output" => result.execution_output,
        "next_actions" => JSON3.write(result.next_actions),
        "techniques_used" => JSON3.write(techniques)
    )
    
    execute_cypher(kg, iteration_query, iteration_params)
    
    # Extract and create ensemble intelligence
    ensemble_info = extract_ensemble_intelligence(result.code_generated, result.evaluation_summary)
    create_ensemble_relationships(kg, experiment.id, iteration, ensemble_info)
    
    # Create cognitive intelligence for learning agents
    create_cognitive_intelligence(kg, "planning_agent", "domain_analysis", result.success)
    create_cognitive_intelligence(kg, "code_generation_agent", "pattern_matching", result.success)
    create_cognitive_intelligence(kg, "evaluation_agent", "performance_assessment", result.success)
    
    # Create domain nodes and relationships
    create_domain_relationships(kg, experiment.id, domain_tags)
    
    # Create technique nodes and relationships  
    create_technique_relationships(kg, experiment.id, iteration, techniques)
    
    # Create code pattern nodes if new patterns detected
    create_code_pattern_relationships(kg, experiment.id, iteration, result.code_generated)
    
    # Find and create similarity relationships
    create_similarity_relationships(kg, experiment.id, experiment.research_question)
    
    @info "Updated Neo4j knowledge graph with advanced intelligence" experiment_id=experiment.id iteration=iteration ensemble_detected=ensemble_info["has_ensemble"]
end

"""
Query similar experiments based on research question similarity
"""
function query_similar_experiments(kg::Neo4jKnowledgeGraph, research_question::String, limit::Int=5)
    query = """
    MATCH (exp:DataMindExperiment)-[:HAS_ITERATION]->(iter:DataMindIteration)
    WHERE exp.research_question CONTAINS \$keyword OR \$keyword CONTAINS exp.research_question
    WITH exp, iter, 
         size(split(toLower(exp.research_question), ' ')) as exp_words,
         size(split(toLower(\$keyword), ' ')) as query_words
    WHERE iter.success = true
    RETURN DISTINCT exp.id as experiment_id,
           exp.research_question as question,
           exp.created_at as created_at,
           collect(iter.metrics) as all_metrics,
           count(iter) as successful_iterations
    ORDER BY successful_iterations DESC, exp.created_at DESC
    LIMIT \$limit
    """
    
    # Extract keywords from research question
    keywords = split(lowercase(research_question), r"\\s+")
    main_keyword = join(keywords[1:min(3, length(keywords))], " ")
    
    params = Dict{String, Any}(
        "keyword" => main_keyword,
        "limit" => limit
    )
    
    result = execute_cypher(kg, query, params)
    
    similar_experiments = []
    if haskey(result, "results") && !isempty(result.results)
        for statement_result in result.results
            if haskey(statement_result, "data")
                for row in statement_result.data
                    push!(similar_experiments, Dict(
                        "experiment_id" => row.row[1],
                        "question" => row.row[2],
                        "created_at" => row.row[3],
                        "successful_iterations" => row.row[5]
                    ))
                end
            end
        end
    end
    
    return similar_experiments
end

"""
Get experiment statistics from the knowledge graph
"""
function get_experiment_statistics(kg::Neo4jKnowledgeGraph)
    query = """
    MATCH (exp:DataMindExperiment)
    OPTIONAL MATCH (exp)-[:HAS_ITERATION]->(iter:DataMindIteration)
    RETURN count(DISTINCT exp) as total_experiments,
           count(iter) as total_iterations,
           count(CASE WHEN iter.success = true THEN 1 END) as successful_iterations,
           avg(CASE WHEN iter.success = true THEN 1.0 ELSE 0.0 END) as success_rate
    """
    
    result = execute_cypher(kg, query)
    
    if haskey(result, "results") && !isempty(result.results)
        data = result.results[1].data
        if !isempty(data)
            row = data[1].row
            return Dict(
                "total_experiments" => row[1],
                "total_iterations" => row[2],
                "successful_iterations" => row[3],
                "success_rate" => row[4]
            )
        end
    end
    
    return Dict(
        "total_experiments" => 0,
        "total_iterations" => 0,
        "successful_iterations" => 0,
        "success_rate" => 0.0
    )
end

"""
Query successful patterns from the knowledge graph
"""
function query_successful_patterns(kg::Neo4jKnowledgeGraph, limit::Int=10)
    query = """
    MATCH (iter:DataMindIteration)
    WHERE iter.success = true AND iter.metrics IS NOT NULL
    WITH iter, 
         keys(apoc.convert.fromJsonMap(iter.metrics)) as metric_keys
    UNWIND metric_keys as metric_key
    WITH metric_key, 
         collect(apoc.convert.fromJsonMap(iter.metrics)[metric_key]) as values
    WHERE size(values) > 1
    RETURN metric_key,
           avg(toFloat(toString(values[0]))) as avg_value,
           count(*) as frequency
    ORDER BY frequency DESC, avg_value DESC
    LIMIT \$limit
    """
    
    params = Dict{String, Any}("limit" => limit)
    
    result = execute_cypher(kg, query, params)
    
    patterns = []
    if haskey(result, "results") && !isempty(result.results)
        for statement_result in result.results
            if haskey(statement_result, "data")
                for row in statement_result.data
                    push!(patterns, Dict(
                        "metric" => row.row[1],
                        "avg_value" => row.row[2],
                        "frequency" => row.row[3]
                    ))
                end
            end
        end
    end
    
    return patterns
end

# Helper functions for enhanced knowledge extraction

"""
Extract domain tags from research question text
"""
function extract_domain_tags(research_question::String)
    question_lower = lowercase(research_question)
    
    # Domain keyword mapping
    domain_keywords = Dict(
        "correlation" => ["correlation", "correlate", "relationship", "association"],
        "regression" => ["regression", "predict", "prediction", "linear", "polynomial"],
        "classification" => ["classification", "classify", "category", "class"],
        "clustering" => ["clustering", "cluster", "group", "segment"],
        "time_series" => ["time", "temporal", "series", "trend", "seasonal"],
        "nlp" => ["text", "language", "sentiment", "topic", "nlp"],
        "computer_vision" => ["image", "vision", "visual", "picture", "cv"],
        "statistics" => ["statistical", "hypothesis", "test", "significance"],
        "machine_learning" => ["model", "training", "learning", "algorithm", "ml"],
        "data_preprocessing" => ["clean", "preprocess", "transform", "normalize"],
        "feature_engineering" => ["feature", "engineering", "selection", "extraction"],
        "visualization" => ["plot", "chart", "graph", "visualize", "display"]
    )
    
    detected_domains = String[]
    for (domain, keywords) in domain_keywords
        if any(keyword -> contains(question_lower, keyword), keywords)
            push!(detected_domains, domain)
        end
    end
    
    return isempty(detected_domains) ? ["general"] : detected_domains
end

"""
Extract techniques used from code and evaluation summary
"""
function extract_techniques(code_generated::String, evaluation_summary::String)
    text = lowercase(code_generated * " " * evaluation_summary)
    
    # Technique patterns
    technique_patterns = Dict(
        "pearson_correlation" => ["cor(", "pearson", "correlation"],
        "spearman_correlation" => ["spearman", "rank correlation"],
        "linear_regression" => ["lm(", "linear", "regression"],
        "logistic_regression" => ["glm(", "logistic"],
        "random_forest" => ["randomforest", "random forest"],
        "svm" => ["svm", "support vector"],
        "k_means" => ["kmeans", "k-means"],
        "pca" => ["pca", "principal component"],
        "t_test" => ["t.test", "t-test", "ttest"],
        "chi_square" => ["chisq", "chi-square", "chi square"],
        "outlier_detection" => ["outlier", "anomaly", "remove_outliers"],
        "normalization" => ["normalize", "scale", "standardize"],
        "cross_validation" => ["cv", "cross-validation", "crossval"]
    )
    
    detected_techniques = String[]
    for (technique, patterns) in technique_patterns
        if any(pattern -> contains(text, pattern), patterns)
            push!(detected_techniques, technique)
        end
    end
    
    return detected_techniques
end

"""
Estimate complexity score for an experiment
"""
function estimate_complexity(research_question::String)
    question_lower = lowercase(research_question)
    complexity_score = 1.0
    
    # Complexity indicators
    if contains(question_lower, "multivariate") || contains(question_lower, "multiple")
        complexity_score += 1.0
    end
    if contains(question_lower, "time series") || contains(question_lower, "temporal")
        complexity_score += 1.5
    end
    if contains(question_lower, "machine learning") || contains(question_lower, "model")
        complexity_score += 1.0
    end
    if contains(question_lower, "deep") || contains(question_lower, "neural")
        complexity_score += 2.0
    end
    if contains(question_lower, "causal") || contains(question_lower, "causality")
        complexity_score += 1.5
    end
    
    return min(complexity_score, 5.0)  # Cap at 5.0
end

"""
Create domain nodes and BELONGS_TO_DOMAIN relationships
"""
function create_domain_relationships(kg::Neo4jKnowledgeGraph, experiment_id::String, domain_tags::Vector{String})
    for domain in domain_tags
        query = """
        MERGE (d:Domain {name: \$domain_name})
        SET d.created_at = coalesce(d.created_at, datetime()),
            d.experiment_count = coalesce(d.experiment_count, 0) + 1
        WITH d
        MATCH (exp:DataMindExperiment {id: \$experiment_id})
        MERGE (exp)-[:BELONGS_TO_DOMAIN]->(d)
        """
        
        params = Dict{String, Any}(
            "domain_name" => domain,
            "experiment_id" => experiment_id
        )
        
        try
            execute_cypher(kg, query, params)
        catch e
            @warn "Failed to create domain relationship" domain=domain error=e
        end
    end
end

"""
Create technique nodes and APPLIES_TECHNIQUE relationships
"""
function create_technique_relationships(kg::Neo4jKnowledgeGraph, experiment_id::String, iteration::Int, techniques::Vector{String})
    for technique in techniques
        query = """
        MERGE (t:Technique {name: \$technique_name})
        SET t.created_at = coalesce(t.created_at, datetime()),
            t.usage_count = coalesce(t.usage_count, 0) + 1,
            t.category = \$category
        WITH t
        MATCH (iter:DataMindIteration {experiment_id: \$experiment_id, iteration: \$iteration})
        MERGE (iter)-[:APPLIES_TECHNIQUE]->(t)
        """
        
        # Categorize techniques
        category = categorize_technique(technique)
        
        params = Dict{String, Any}(
            "technique_name" => technique,
            "experiment_id" => experiment_id,
            "iteration" => iteration,
            "category" => category
        )
        
        try
            execute_cypher(kg, query, params)
        catch e
            @warn "Failed to create technique relationship" technique=technique error=e
        end
    end
end

"""
Categorize techniques into broader categories
"""
function categorize_technique(technique::String)
    if contains(technique, "correlation")
        return "statistical_analysis"
    elseif contains(technique, "regression")
        return "regression_analysis"
    elseif contains(technique, "forest") || contains(technique, "svm")
        return "machine_learning"
    elseif contains(technique, "test") || contains(technique, "chi")
        return "hypothesis_testing"
    elseif contains(technique, "outlier") || contains(technique, "normalize")
        return "data_preprocessing"
    else
        return "general"
    end
end

"""
Create code pattern nodes for reusable code snippets
"""
function create_code_pattern_relationships(kg::Neo4jKnowledgeGraph, experiment_id::String, iteration::Int, code_generated::String)
    # Extract meaningful code patterns (simplified pattern recognition)
    patterns = extract_code_patterns(code_generated)
    
    for pattern in patterns
        query = """
        MERGE (p:CodePattern {id: \$pattern_id})
        SET p.name = \$pattern_name,
            p.template = \$template,
            p.category = \$category,
            p.usage_count = coalesce(p.usage_count, 0) + 1,
            p.created_at = coalesce(p.created_at, datetime())
        WITH p
        MATCH (iter:DataMindIteration {experiment_id: \$experiment_id, iteration: \$iteration})
        MERGE (iter)-[:USES_PATTERN]->(p)
        """
        
        pattern_id = "pattern_" * replace(pattern["name"], " " => "_")
        
        params = Dict{String, Any}(
            "pattern_id" => pattern_id,
            "pattern_name" => pattern["name"],
            "template" => pattern["template"],
            "category" => pattern["category"],
            "experiment_id" => experiment_id,
            "iteration" => iteration
        )
        
        try
            execute_cypher(kg, query, params)
        catch e
            @warn "Failed to create code pattern relationship" pattern=pattern["name"] error=e
        end
    end
end

"""
Extract code patterns from generated code
"""
function extract_code_patterns(code_generated::String)
    patterns = []
    code_lower = lowercase(code_generated)
    
    # Basic correlation pattern
    if contains(code_lower, "cor(")
        push!(patterns, Dict(
            "name" => "correlation_analysis",
            "template" => "cor(x, y)",
            "category" => "statistical_analysis"
        ))
    end
    
    # Outlier removal pattern
    if contains(code_lower, "outlier") || contains(code_lower, "remove")
        push!(patterns, Dict(
            "name" => "outlier_removal",
            "template" => "remove_outliers(data)",
            "category" => "data_preprocessing"
        ))
    end
    
    # Linear model pattern
    if contains(code_lower, "lm(") || contains(code_lower, "linear")
        push!(patterns, Dict(
            "name" => "linear_modeling",
            "template" => "lm(y ~ x, data)",
            "category" => "regression_analysis"
        ))
    end
    
    return patterns
end

"""
Create similarity relationships between experiments
"""
function create_similarity_relationships(kg::Neo4jKnowledgeGraph, experiment_id::String, research_question::String)
    # Find similar experiments based on text similarity and shared domains
    query = """
    MATCH (exp1:DataMindExperiment {id: \$experiment_id})
    MATCH (exp2:DataMindExperiment)
    WHERE exp1.id <> exp2.id
    AND any(tag1 IN exp1.domain_tags WHERE tag1 IN exp2.domain_tags)
    WITH exp1, exp2, 
         size([tag IN exp1.domain_tags WHERE tag IN exp2.domain_tags]) as shared_domains,
         size(exp1.domain_tags + exp2.domain_tags) - size([tag IN exp1.domain_tags WHERE tag IN exp2.domain_tags]) as total_unique_domains
    WHERE shared_domains > 0
    WITH exp1, exp2, toFloat(shared_domains) / total_unique_domains as similarity_score
    WHERE similarity_score > 0.3
    MERGE (exp1)-[r:SIMILAR_TO]->(exp2)
    SET r.similarity_score = similarity_score,
        r.created_at = datetime()
    """
    
    params = Dict{String, Any}("experiment_id" => experiment_id)
    
    try
        execute_cypher(kg, query, params)
    catch e
        @warn "Failed to create similarity relationships" experiment_id=experiment_id error=e
    end
end

# Export the functions
export Neo4jKnowledgeGraph, create_neo4j_knowledge_graph, initialize_schema, 
       update_knowledge, query_similar_experiments, get_experiment_statistics,
       query_successful_patterns, query_techniques_for_domain, query_code_patterns,
       query_experiment_lineage, query_cross_domain_patterns, query_similarity_relationships,
       query_domain_statistics

"""
Query techniques that work well for a specific domain
"""
function query_techniques_for_domain(kg::Neo4jKnowledgeGraph, domain_name::String, limit::Int=10)
    query = """
    MATCH (d:Domain {name: \$domain_name})<-[:BELONGS_TO_DOMAIN]-(exp:DataMindExperiment)
    MATCH (exp)-[:HAS_ITERATION]->(iter:DataMindIteration {success: true})
    MATCH (iter)-[:APPLIES_TECHNIQUE]->(t:Technique)
    RETURN t.name as technique,
           t.category as category,
           count(*) as success_count,
           count(iter) as total_usage
    ORDER BY success_count DESC
    LIMIT \$limit
    """
    
    params = Dict{String, Any}(
        "domain_name" => domain_name,
        "limit" => limit
    )
    
    result = execute_cypher(kg, query, params)
    
    techniques = []
    if haskey(result, "results") && !isempty(result.results)
        for statement_result in result.results
            if haskey(statement_result, "data")
                for row in statement_result.data
                    push!(techniques, Dict(
                        "technique" => row.row[1],
                        "category" => row.row[2],
                        "success_count" => row.row[3],
                        "total_usage" => row.row[4]
                    ))
                end
            end
        end
    end
    
    return techniques
end

"""
Query reusable code patterns with success metrics
"""
function query_code_patterns(kg::Neo4jKnowledgeGraph, category::String="", limit::Int=10)
    where_clause = isempty(category) ? "" : "WHERE p.category = \$category"
    
    query = """
    MATCH (p:CodePattern)<-[:USES_PATTERN]-(iter:DataMindIteration)
    $where_clause
    WITH p, count(*) as total_usage, sum(case when iter.success then 1 else 0 end) as successful_usage
    RETURN p.name as pattern_name,
           p.template as template,
           p.category as category,
           total_usage,
           successful_usage,
           toFloat(successful_usage) / total_usage as success_rate
    ORDER BY success_rate DESC, total_usage DESC
    LIMIT \$limit
    """
    
    params = Dict{String, Any}("limit" => limit)
    if !isempty(category)
        params["category"] = category
    end
    
    result = execute_cypher(kg, query, params)
    
    patterns = []
    if haskey(result, "results") && !isempty(result.results)
        for statement_result in result.results
            if haskey(statement_result, "data")
                for row in statement_result.data
                    push!(patterns, Dict(
                        "pattern_name" => row.row[1],
                        "template" => row.row[2],
                        "category" => row.row[3],
                        "total_usage" => row.row[4],
                        "successful_usage" => row.row[5],
                        "success_rate" => row.row[6]
                    ))
                end
            end
        end
    end
    
    return patterns
end

"""
Query experiment lineage and relationships
"""
function query_experiment_lineage(kg::Neo4jKnowledgeGraph, experiment_id::String)
    query = """
    MATCH (exp:DataMindExperiment {id: \$experiment_id})
    OPTIONAL MATCH (exp)-[r:SIMILAR_TO]->(similar:DataMindExperiment)
    OPTIONAL MATCH (exp)-[:BELONGS_TO_DOMAIN]->(domain:Domain)
    OPTIONAL MATCH (exp)-[:HAS_ITERATION]->(iter:DataMindIteration)-[:APPLIES_TECHNIQUE]->(tech:Technique)
    RETURN exp.research_question as question,
           exp.domain_tags as domains,
           collect(DISTINCT similar.research_question) as similar_experiments,
           collect(DISTINCT tech.name) as techniques_used,
           collect(DISTINCT r.similarity_score) as similarity_scores
    """
    
    params = Dict{String, Any}("experiment_id" => experiment_id)
    
    result = execute_cypher(kg, query, params)
    
    if haskey(result, "results") && !isempty(result.results)
        data = result.results[1].data
        if !isempty(data)
            row = data[1].row
            return Dict(
                "question" => row[1],
                "domains" => row[2],
                "similar_experiments" => filter(!isnothing, row[3]),
                "techniques_used" => filter(!isnothing, row[4]),
                "similarity_scores" => filter(!isnothing, row[5])
            )
        end
    end
    
    return Dict()
end

"""
Query patterns that work across different domains (transfer learning opportunities)
"""
function query_cross_domain_patterns(kg::Neo4jKnowledgeGraph, limit::Int=10)
    query = """
    MATCH (d1:Domain)<-[:BELONGS_TO_DOMAIN]-(exp1:DataMindExperiment)-[:HAS_ITERATION]->(iter1:DataMindIteration {success: true})
    MATCH (iter1)-[:USES_PATTERN]->(pattern:CodePattern)
    MATCH (pattern)<-[:USES_PATTERN]-(iter2:DataMindIteration {success: true})<-[:HAS_ITERATION]-(exp2:DataMindExperiment)-[:BELONGS_TO_DOMAIN]->(d2:Domain)
    WHERE d1.name <> d2.name
    WITH pattern, d1, d2, count(*) as cross_domain_usage
    RETURN pattern.name as pattern_name,
           pattern.category as category,
           d1.name as domain1,
           d2.name as domain2,
           cross_domain_usage
    ORDER BY cross_domain_usage DESC
    LIMIT \$limit
    """
    
    params = Dict{String, Any}("limit" => limit)
    
    result = execute_cypher(kg, query, params)
    
    patterns = []
    if haskey(result, "results") && !isempty(result.results)
        for statement_result in result.results
            if haskey(statement_result, "data")
                for row in statement_result.data
                    push!(patterns, Dict(
                        "pattern_name" => row.row[1],
                        "category" => row.row[2],
                        "domain1" => row.row[3],
                        "domain2" => row.row[4],
                        "cross_domain_usage" => row.row[5]
                    ))
                end
            end
        end
    end
    
    return patterns
end

"""
Query similarity relationships between experiments
"""
function query_similarity_relationships(kg::Neo4jKnowledgeGraph, limit::Int=10)
    query = """
    MATCH (exp1:DataMindExperiment)-[r:SIMILAR_TO]->(exp2:DataMindExperiment)
    RETURN exp1.research_question as exp1_question,
           exp2.research_question as exp2_question,
           r.similarity_score as similarity
    ORDER BY r.similarity_score DESC
    LIMIT \$limit
    """
    
    params = Dict{String, Any}("limit" => limit)
    
    result = execute_cypher(kg, query, params)
    
    similarities = []
    if haskey(result, "results") && !isempty(result.results)
        for statement_result in result.results
            if haskey(statement_result, "data")
                for row in statement_result.data
                    push!(similarities, Dict(
                        "exp1_question" => row.row[1],
                        "exp2_question" => row.row[2],
                        "similarity_score" => row.row[3]
                    ))
                end
            end
        end
    end
    
    return similarities
end

"""
Query domain statistics and experiment counts
"""
function query_domain_statistics(kg::Neo4jKnowledgeGraph)
    query = """
    MATCH (d:Domain)<-[:BELONGS_TO_DOMAIN]-(exp:DataMindExperiment)
    RETURN d.name as domain_name, 
           count(exp) as experiment_count,
           d.created_at as domain_created
    ORDER BY experiment_count DESC, domain_name ASC
    """
    
    result = execute_cypher(kg, query)
    
    domains = []
    if haskey(result, "results") && !isempty(result.results)
        for statement_result in result.results
            if haskey(statement_result, "data")
                for row in statement_result.data
                    push!(domains, Dict(
                        "domain_name" => row.row[1],
                        "experiment_count" => row.row[2],
                        "domain_created" => row.row[3]
                    ))
                end
            end
        end
    end
    
    return domains
end

# ========================================
# 🎪 ENSEMBLE METHODS INTELLIGENCE
# ========================================

"""
Extract ensemble method information from code and create ensemble intelligence nodes
"""
function extract_ensemble_intelligence(code::String, evaluation_summary::String)
    ensemble_info = Dict{String, Any}()
    
    # Detect ensemble methods in code
    ensemble_patterns = [
        ("stacking", r"(?i)stack|meta.*learn|blend"),
        ("bagging", r"(?i)bag|bootstrap|random.*forest|extra.*tree"),
        ("boosting", r"(?i)boost|adaboost|gradient.*boost|xgboost|lightgbm|catboost"),
        ("voting", r"(?i)voting|vote|ensemble|combine"),
        ("bayesian_ensemble", r"(?i)bayesian.*ensemble|model.*average|posterior.*sample")
    ]
    
    detected_methods = []
    for (method_type, pattern) in ensemble_patterns
        if occursin(pattern, code) || occursin(pattern, evaluation_summary)
            push!(detected_methods, method_type)
        end
    end
    
    if !isempty(detected_methods)
        ensemble_info["methods"] = detected_methods
        ensemble_info["has_ensemble"] = true
        
        # Extract base model information
        base_model_patterns = [
            ("decision_tree", r"(?i)decision.*tree|tree|dt"),
            ("random_forest", r"(?i)random.*forest|rf"),
            ("svm", r"(?i)svm|support.*vector"),
            ("neural_network", r"(?i)neural|nn|mlp|deep"),
            ("linear_model", r"(?i)linear|logistic|regression"),
            ("naive_bayes", r"(?i)naive.*bayes|nb"),
            ("knn", r"(?i)k.*nearest|knn")
        ]
        
        base_models = []
        for (model_type, pattern) in base_model_patterns
            if occursin(pattern, code)
                push!(base_models, model_type)
            end
        end
        ensemble_info["base_models"] = base_models
        
        # Extract performance metrics if available
        if occursin(r"(?i)accuracy|auc|f1|precision|recall|rmse|mae", evaluation_summary)
            ensemble_info["has_performance_metrics"] = true
        end
    else
        ensemble_info["has_ensemble"] = false
    end
    
    return ensemble_info
end

"""
Create ensemble method nodes and relationships in the knowledge graph
"""
function create_ensemble_relationships(kg::Neo4jKnowledgeGraph, experiment_id::String, iteration::Int, ensemble_info::Dict)
    if !get(ensemble_info, "has_ensemble", false)
        return
    end
    
    for method_type in get(ensemble_info, "methods", [])
        # Create EnsembleMethod node
        ensemble_id = "ensemble_$(experiment_id)_$(iteration)_$(method_type)"
        
        create_query = """
        MERGE (em:EnsembleMethod {id: \$ensemble_id})
        SET em.name = \$method_type,
            em.type = \$method_type,
            em.created_at = datetime(),
            em.combination_strategy = CASE \$method_type
                WHEN 'stacking' THEN 'meta_learning'
                WHEN 'bagging' THEN 'averaging'
                WHEN 'boosting' THEN 'sequential_weighting'
                WHEN 'voting' THEN 'majority_vote'
                WHEN 'bayesian_ensemble' THEN 'posterior_averaging'
                ELSE 'unknown'
            END,
            em.diversity_mechanism = CASE \$method_type
                WHEN 'stacking' THEN 'model_diversity'
                WHEN 'bagging' THEN 'data_sampling'
                WHEN 'boosting' THEN 'error_focusing'
                WHEN 'voting' THEN 'algorithm_diversity'
                WHEN 'bayesian_ensemble' THEN 'prior_diversity'
                ELSE 'unknown'
            END
        
        WITH em
        MATCH (i:DataMindIteration {experiment_id: \$experiment_id, iteration: \$iteration})
        MERGE (i)-[:USES_ENSEMBLE_METHOD]->(em)
        """
        
        try
            execute_cypher(kg, create_query, Dict{String, Any}(
                "ensemble_id" => ensemble_id,
                "method_type" => method_type,
                "experiment_id" => experiment_id,
                "iteration" => iteration
            ))
        catch e
            @warn "Failed to create ensemble method node" error=e
        end
        
        # Create base model nodes and relationships
        for (i, base_model) in enumerate(get(ensemble_info, "base_models", []))
            base_model_id = "base_model_$(experiment_id)_$(iteration)_$(method_type)_$(i)"
            
            base_model_query = """
            MERGE (bm:BaseModel {id: \$base_model_id})
            SET bm.model_type = \$base_model,
                bm.created_at = datetime(),
                bm.ensemble_position = \$position
            
            WITH bm
            MATCH (em:EnsembleMethod {id: \$ensemble_id})
            MERGE (em)-[:CONTAINS_BASE_MODEL]->(bm)
            """
            
            try
                execute_cypher(kg, base_model_query, Dict{String, Any}(
                    "base_model_id" => base_model_id,
                    "base_model" => base_model,
                    "position" => i,
                    "ensemble_id" => ensemble_id
                ))
            catch e
                @warn "Failed to create base model node" error=e
            end
        end
        
        # Create method-specific intelligence nodes
        if method_type == "stacking"
            create_stacking_intelligence(kg, ensemble_id, experiment_id, iteration)
        elseif method_type == "bagging"
            create_bagging_intelligence(kg, ensemble_id, experiment_id, iteration)
        elseif method_type == "boosting"
            create_boosting_intelligence(kg, ensemble_id, experiment_id, iteration)
        elseif method_type == "bayesian_ensemble"
            create_bayesian_ensemble_intelligence(kg, ensemble_id, experiment_id, iteration)
        end
    end
end

"""
Create stacking-specific intelligence nodes
"""
function create_stacking_intelligence(kg::Neo4jKnowledgeGraph, ensemble_id::String, experiment_id::String, iteration::Int)
    meta_learner_id = "meta_learner_$(ensemble_id)"
    
    query = """
    MERGE (ml:MetaLearner {id: \$meta_learner_id})
    SET ml.algorithm = 'logistic_regression',
        ml.cross_validation_strategy = 'k_fold',
        ml.feature_engineering = 'base_predictions',
        ml.overfitting_prevention = 'regularization',
        ml.created_at = datetime()
    
    WITH ml
    MATCH (em:EnsembleMethod {id: \$ensemble_id})
    MERGE (em)-[:EMPLOYS_META_LEARNER]->(ml)
    
    MERGE (sl:StackingLevel {id: \$stacking_level_id})
    SET sl.level_number = 1,
        sl.model_diversity = 'high',
        sl.feature_representation = 'predictions',
        sl.information_leakage_prevention = 'cross_validation',
        sl.created_at = datetime()
    
    WITH sl
    MATCH (em:EnsembleMethod {id: \$ensemble_id})
    MERGE (em)-[:HAS_STACKING_LEVEL]->(sl)
    """
    
    try
        execute_cypher(kg, query, Dict{String, Any}(
            "meta_learner_id" => meta_learner_id,
            "ensemble_id" => ensemble_id,
            "stacking_level_id" => "stacking_level_$(ensemble_id)"
        ))
    catch e
        @warn "Failed to create stacking intelligence" error=e
    end
end

"""
Create bagging-specific intelligence nodes
"""
function create_bagging_intelligence(kg::Neo4jKnowledgeGraph, ensemble_id::String, experiment_id::String, iteration::Int)
    bootstrap_id = "bootstrap_$(ensemble_id)"
    
    query = """
    MERGE (bs:BootstrapStrategy {id: \$bootstrap_id})
    SET bs.sampling_method = 'bootstrap_sampling',
        bs.replacement_policy = 'with_replacement',
        bs.sample_size_ratio = 1.0,
        bs.diversity_injection = 'data_sampling',
        bs.variance_reduction_effectiveness = 'high',
        bs.created_at = datetime()
    
    WITH bs
    MATCH (em:EnsembleMethod {id: \$ensemble_id})
    MERGE (em)-[:USES_BOOTSTRAP_STRATEGY]->(bs)
    """
    
    try
        execute_cypher(kg, query, Dict{String, Any}(
            "bootstrap_id" => bootstrap_id,
            "ensemble_id" => ensemble_id
        ))
    catch e
        @warn "Failed to create bagging intelligence" error=e
    end
end

"""
Create boosting-specific intelligence nodes
"""
function create_boosting_intelligence(kg::Neo4jKnowledgeGraph, ensemble_id::String, experiment_id::String, iteration::Int)
    boosting_sequence_id = "boosting_seq_$(ensemble_id)"
    
    query = """
    MERGE (bs:BoostingSequence {id: \$boosting_sequence_id})
    SET bs.algorithm_type = 'gradient_boosting',
        bs.learning_rate = 0.1,
        bs.regularization = 'l2',
        bs.early_stopping_criteria = 'validation_loss',
        bs.bias_reduction_strategy = 'sequential_correction',
        bs.created_at = datetime()
    
    WITH bs
    MATCH (em:EnsembleMethod {id: \$ensemble_id})
    MERGE (em)-[:HAS_BOOSTING_SEQUENCE]->(bs)
    
    // Create weak learner nodes
    MERGE (wl:WeakLearner {id: \$weak_learner_id})
    SET wl.complexity_level = 'low',
        wl.error_rate = 0.49,
        wl.complementary_strength = 'bias_reduction',
        wl.boosting_contribution = 'error_correction',
        wl.iteration_number = 1,
        wl.created_at = datetime()
    
    WITH wl
    MATCH (bs:BoostingSequence {id: \$boosting_sequence_id})
    MERGE (bs)-[:CONTAINS_WEAK_LEARNER]->(wl)
    """
    
    try
        execute_cypher(kg, query, Dict{String, Any}(
            "boosting_sequence_id" => boosting_sequence_id,
            "ensemble_id" => ensemble_id,
            "weak_learner_id" => "weak_learner_$(ensemble_id)_1"
        ))
    catch e
        @warn "Failed to create boosting intelligence" error=e
    end
end

"""
Create Bayesian ensemble-specific intelligence nodes
"""
function create_bayesian_ensemble_intelligence(kg::Neo4jKnowledgeGraph, ensemble_id::String, experiment_id::String, iteration::Int)
    prior_id = "bayesian_prior_$(ensemble_id)"
    posterior_id = "model_posterior_$(ensemble_id)"
    
    query = """
    MERGE (bp:BayesianPrior {id: \$prior_id})
    SET bp.prior_type = 'dirichlet_process',
        bp.hyperprior_specification = 'jeffreys_prior',
        bp.uncertainty_quantification = 'full_posterior',
        bp.model_space_coverage = 'nonparametric',
        bp.posterior_approximation_method = 'mcmc',
        bp.created_at = datetime()
    
    MERGE (mp:ModelPosterior {id: \$posterior_id})
    SET mp.posterior_samples = 1000,
        mp.credible_intervals = '95_percent',
        mp.model_uncertainty = 'epistemic',
        mp.predictive_distribution = 'mixture',
        mp.convergence_diagnostics = 'rhat',
        mp.created_at = datetime()
    
    MERGE (np:NonparametricProcess {id: \$nonparametric_id})
    SET np.process_type = 'dirichlet_process',
        np.flexibility_level = 'infinite',
        np.capacity_control = 'concentration_parameter',
        np.inference_method = 'variational_bayes',
        np.scalability_characteristics = 'approximate',
        np.created_at = datetime()
    
    WITH bp, mp, np
    MATCH (em:EnsembleMethod {id: \$ensemble_id})
    MERGE (em)-[:HAS_BAYESIAN_PRIOR]->(bp)
    MERGE (bp)-[:UPDATES_TO_POSTERIOR]->(mp)
    MERGE (em)-[:USES_NONPARAMETRIC_PROCESS]->(np)
    """
    
    try
        execute_cypher(kg, query, Dict{String, Any}(
            "prior_id" => prior_id,
            "posterior_id" => posterior_id,
            "nonparametric_id" => "nonparametric_$(ensemble_id)",
            "ensemble_id" => ensemble_id
        ))
    catch e
        @warn "Failed to create Bayesian ensemble intelligence" error=e
    end
end

# ========================================
# 🧠 COGNITIVE & LEARNING INTELLIGENCE
# ========================================

"""
Create agent intelligence nodes and learning relationships
"""
function create_cognitive_intelligence(kg::Neo4jKnowledgeGraph, agent_name::String, strategy_used::String, success::Bool)
    agent_id = "agent_$(agent_name)"
    strategy_id = "strategy_$(strategy_used)_$(agent_name)"
    
    query = """
    MERGE (a:Agent {name: \$agent_name})
    SET a.type = \$agent_name,
        a.expertise_level = COALESCE(a.expertise_level, 0.5) + CASE WHEN \$success THEN 0.01 ELSE -0.005 END,
        a.learning_rate = 0.1,
        a.last_updated = datetime()
    
    MERGE (s:Strategy {id: \$strategy_id})
    SET s.name = \$strategy_used,
        s.description = 'Strategy employed by ' + \$agent_name,
        s.domain = 'general',
        s.success_rate = COALESCE(s.success_rate, 0.5),
        s.conditions = 'adaptive',
        s.usage_count = COALESCE(s.usage_count, 0) + 1,
        s.last_used = datetime()
    
    WITH a, s
    MERGE (a)-[:EMPLOYS_STRATEGY {confidence: 0.8, last_used: datetime()}]->(s)
    
    // Update strategy success rate
    WITH s
    MATCH (a)-[r:EMPLOYS_STRATEGY]->(s)
    WITH s, COUNT(r) as total_usage
    OPTIONAL MATCH (i:DataMindIteration)-[:USED_STRATEGY]->(s)
    WHERE i.success = true
    WITH s, total_usage, COUNT(i) as successful_usage
    SET s.success_rate = CASE WHEN total_usage > 0 THEN toFloat(successful_usage) / total_usage ELSE 0.5 END
    """
    
    try
        execute_cypher(kg, query, Dict{String, Any}(
            "agent_name" => agent_name,
            "strategy_used" => strategy_used,
            "strategy_id" => strategy_id,
            "success" => success
        ))
    catch e
        @warn "Failed to create cognitive intelligence" error=e
    end
end

"""
Query ensemble intelligence recommendations for a domain
"""
function query_ensemble_recommendations(kg::Neo4jKnowledgeGraph, domain::String, data_size::String="medium")
    query = """
    MATCH (em:EnsembleMethod)<-[:USES_ENSEMBLE_METHOD]-(i:DataMindIteration)<-[:HAS_ITERATION]-(e:DataMindExperiment)
    WHERE ANY(tag IN e.domain_tags WHERE toLower(tag) CONTAINS toLower(\$domain))
    AND i.success = true
    
    WITH em, COUNT(i) as usage_count, AVG(i.effectiveness_score) as avg_effectiveness
    WHERE usage_count >= 2
    
    OPTIONAL MATCH (em)-[:CONTAINS_BASE_MODEL]->(bm:BaseModel)
    
    RETURN em.type as ensemble_method,
           em.combination_strategy as strategy,
           em.diversity_mechanism as diversity,
           usage_count,
           avg_effectiveness,
           COLLECT(DISTINCT bm.model_type) as base_models
    ORDER BY avg_effectiveness DESC, usage_count DESC
    LIMIT 5
    """
    
    result = execute_cypher(kg, query, Dict{String, Any}("domain" => domain))
    
    recommendations = []
    if haskey(result, "results") && !isempty(result.results)
        for statement_result in result.results
            if haskey(statement_result, "data")
                for row in statement_result.data
                    push!(recommendations, Dict(
                        "ensemble_method" => row.row[1],
                        "strategy" => row.row[2],
                        "diversity" => row.row[3],
                        "usage_count" => row.row[4],
                        "avg_effectiveness" => row.row[5],
                        "base_models" => row.row[6]
                    ))
                end
            end
        end
    end
    
    return recommendations
end

"""
Query learning patterns and meta-cognitive insights
"""
function query_learning_intelligence(kg::Neo4jKnowledgeGraph, agent_name::String)
    query = """
    MATCH (a:Agent {name: \$agent_name})-[:EMPLOYS_STRATEGY]->(s:Strategy)
    
    OPTIONAL MATCH (a)-[:LEARNS_RULE]->(dr:DecisionRule)
    OPTIONAL MATCH (a)-[:UPDATES_BELIEF]->(ks:KnowledgeState)
    
    RETURN a.expertise_level as expertise,
           a.learning_rate as learning_rate,
           COLLECT(DISTINCT {
               strategy: s.name,
               success_rate: s.success_rate,
               usage_count: s.usage_count
           }) as strategies,
           COUNT(DISTINCT dr) as decision_rules_learned,
           COUNT(DISTINCT ks) as knowledge_states
    """
    
    result = execute_cypher(kg, query, Dict{String, Any}("agent_name" => agent_name))
    
    intelligence = Dict()
    if haskey(result, "results") && !isempty(result.results)
        for statement_result in result.results
            if haskey(statement_result, "data") && !isempty(statement_result.data)
                row = statement_result.data[1]
                intelligence = Dict(
                    "expertise_level" => row.row[1],
                    "learning_rate" => row.row[2],
                    "strategies" => row.row[3],
                    "decision_rules_learned" => row.row[4],
                    "knowledge_states" => row.row[5]
                )
            end
        end
    end
    
    return intelligence
end