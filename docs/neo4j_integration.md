# Neo4j Knowledge Graph Integration

The DSAssist system now supports external Neo4j graph database integration for enhanced knowledge management and experiment tracking.

## Overview

The knowledge graph component has been enhanced with dual-backend support:
- **Neo4j Backend**: For production use with persistent, queryable graph storage
- **In-Memory Backend**: Fallback option for development and when Neo4j is unavailable

## Configuration

### Environment Variables

Add the following to your `.env` file:

```bash
# Neo4j Database Configuration
NEO4J_URI=bolt://localhost:7687      # Standard Neo4j bolt URI
NEO4J_USER=neo4j                     # Database username
NEO4J_PASSWORD=your_password_here    # Database password
```

**Note**: The system automatically converts bolt:// URIs to http:// endpoints for the HTTP API integration.

### Neo4j Setup

1. **Install Neo4j Desktop** or use Neo4j Community/Enterprise
2. **Create a database** with authentication enabled
3. **Note your credentials** - Neo4j Desktop generates random passwords
4. **Update your .env file** with the correct credentials

### Credential Discovery

If you're unsure of your Neo4j credentials, use the discovery script:

```bash
julia --project=. scripts/discover_neo4j_credentials.jl
```

This interactive script will help you find and test your Neo4j connection.

## Features

### Automatic Backend Selection

The system automatically detects Neo4j availability:

```julia
kg = KnowledgeGraph()
# Will use Neo4j if available, fall back to in-memory if not
```

### Experiment Tracking

The Neo4j backend provides comprehensive experiment tracking:

- **Experiment Nodes**: Store research questions, metadata, and status
- **Iteration Nodes**: Track each experiment iteration with metrics and outcomes
- **Relationships**: Link experiments to iterations and similar experiments
- **Indices**: Optimized queries for research questions, success rates, and timestamps

### Schema

```cypher
# Experiment nodes
(e:DSAssistExperiment {
    id: String,
    research_question: String,
    created_at: DateTime,
    updated_at: DateTime,
    status: String
})

# Iteration nodes
(i:DSAssistIteration {
    experiment_id: String,
    iteration: Integer,
    success: Boolean,
    metrics: Map,
    code_generated: String,
    execution_output: String,
    evaluation_summary: String,
    artifacts: List[String],
    next_actions: List[String],
    created_at: DateTime
})

# Relationships
(e)-[:HAS_ITERATION]->(i)
(e)-[:SIMILAR_TO]->(other_e)
```

### Query Capabilities

#### Basic Usage

```julia
using DSAssist

# Create knowledge graph (auto-detects backend)
kg = KnowledgeGraph()

# Track an experiment
experiment = Experiment("Analyze correlation between temperature and sales")
result = ExperimentResult(
    true,  # success
    Dict("correlation" => 0.78, "p_value" => 0.001),  # metrics
    ["correlation_plot.png"],  # artifacts
    "correlation_code",  # code_generated
    "Analysis completed",  # execution_output
    "Strong positive correlation found",  # evaluation_summary
    ["explore_causality"]  # next_actions
)

# Update knowledge graph
update_knowledge(kg, experiment, result)

# Query insights
insights = query_insights(kg, "correlation analysis patterns")
```

#### Advanced Queries

The Neo4j backend supports sophisticated pattern matching:

```julia
# Find similar experiments
insights = query_insights(kg, "correlation analysis patterns")
similar_exps = insights["similar_experiments"]

# Get performance patterns
ml_insights = query_insights(kg, "machine learning model performance")
patterns = ml_insights["successful_patterns"]

# Overall statistics
stats_insights = query_insights(kg, "experiment statistics")
stats = stats_insights["statistics"]
```

### Fallback Behavior

If Neo4j is unavailable, the system gracefully falls back to in-memory storage:

- No data loss during the session
- Same API interface
- Automatic detection and warnings
- Seamless switching when Neo4j becomes available

## Testing

### Basic Integration Test

```bash
julia --project=. scripts/test_neo4j_integration.jl
```

### Advanced Features Test

```bash
julia --project=. scripts/test_neo4j_advanced.jl
```

### Fallback Behavior Test

```bash
julia --project=. scripts/test_fallback_behavior.jl
```

## API Reference

### KnowledgeGraph Constructor

```julia
kg = KnowledgeGraph()
```

Automatically detects and initializes the best available backend.

### update_knowledge

```julia
update_knowledge(kg::KnowledgeGraph, experiment::Experiment, result::ExperimentResult)
```

Updates the knowledge graph with experiment results.

### query_insights

```julia
insights = query_insights(kg::KnowledgeGraph, query::String)
```

Queries the knowledge graph for patterns and insights.

#### Return Format

```julia
Dict(
    "statistics" => Dict(
        "total_experiments" => Int,
        "total_iterations" => Int,
        "success_rate" => Float64,
        "most_common_metrics" => Vector{Dict}
    ),
    "similar_experiments" => Vector{Dict(
        "id" => String,
        "question" => String,
        "similarity_score" => Float64
    )},
    "successful_patterns" => Vector{Dict(
        "metric" => String,
        "avg_value" => Float64,
        "experiment_count" => Int
    )},
    "recent_experiments" => Vector{Dict}
)
```

## Performance Considerations

### Neo4j Advantages

- **Persistent Storage**: Data survives application restarts
- **Complex Queries**: Graph traversals and pattern matching
- **Scalability**: Handles large numbers of experiments efficiently
- **Analytics**: Built-in graph algorithms and statistics

### In-Memory Advantages

- **Speed**: Faster for small datasets and development
- **Simplicity**: No external dependencies
- **Testing**: Isolated test environments

## Troubleshooting

### Connection Issues

1. **Check Neo4j Status**: Ensure Neo4j is running
2. **Verify Credentials**: Use the credential discovery script
3. **Port Configuration**: Ensure ports 7474 (HTTP) and 7687 (Bolt) are accessible
4. **Firewall**: Check firewall settings for local connections

### Performance Issues

1. **Index Creation**: The system automatically creates necessary indices
2. **Query Optimization**: Complex queries may need Neo4j query tuning
3. **Memory Settings**: Adjust Neo4j memory settings for large datasets

### Data Migration

To migrate from in-memory to Neo4j:

1. Set up Neo4j credentials in `.env`
2. Restart the application
3. Re-run experiments to populate Neo4j
4. Historical in-memory data will need manual migration if required

## Integration with DSAssist Agents

The Neo4j knowledge graph integrates seamlessly with all DSAssist agents:

- **Meta-Controller**: Uses insights for planning decisions
- **Planning Agent**: Queries similar experiments for context
- **Evaluation Agent**: Stores results and compares with historical data
- **Reflection Agent**: Analyzes patterns across experiment history

This provides a comprehensive knowledge management system that grows smarter with each experiment iteration.