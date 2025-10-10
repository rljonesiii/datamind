# DSAssist Knowledge Graph Ontology

## Current State Analysis
Currently, the Neo4j knowledge graph only has:
- **Nodes**: `DSAssistExperiment`, `DSAssistIteration`  
- **Relationships**: `HAS_ITERATION`

This is too simplistic for capturing the full richness of data science knowledge.

## Proposed Comprehensive Ontology

### Node Types

#### Core Experiment Nodes
- **DSAssistExperiment**: Research questions and high-level goals
- **DSAssistIteration**: Specific attempts with code and results
- **DSAssistPlan**: Planning outputs and task decompositions
- **DSAssistEvaluation**: Evaluation results and insights

#### Knowledge Artifacts
- **CodePattern**: Reusable code templates and snippets
- **DataPattern**: Data preprocessing and feature engineering patterns  
- **MetricPattern**: Performance measurement and evaluation approaches
- **FailurePattern**: Common failure modes and anti-patterns

#### Domain Knowledge
- **Domain**: Data science domains (NLP, Computer Vision, Time Series, etc.)
- **Technique**: Specific methods (correlation, regression, clustering, etc.)
- **Dataset**: Data sources and characteristics
- **Tool**: Libraries, frameworks, and tools used

#### Conceptual Knowledge
- **Concept**: Data science concepts (overfitting, feature engineering, etc.)
- **Assumption**: Modeling assumptions and prerequisites
- **Insight**: Discovered patterns and learnings
- **Hypothesis**: Testable claims and theories

### Relationship Types

#### Experiment Relationships
- **HAS_ITERATION**: Experiment → Iteration (current)
- **HAS_PLAN**: Experiment → Plan  
- **HAS_EVALUATION**: Iteration → Evaluation
- **BUILDS_ON**: Experiment → Experiment (lineage)
- **SIMILAR_TO**: Experiment ↔ Experiment (similarity)
- **IMPROVES**: Experiment → Experiment (refinement)
- **INVALIDATES**: Experiment → Experiment (contradicts findings)

#### Knowledge Relationships  
- **USES_PATTERN**: Iteration → CodePattern/DataPattern/MetricPattern
- **DISCOVERS_PATTERN**: Iteration → Pattern (new pattern found)
- **APPLIES_TECHNIQUE**: Iteration → Technique
- **BELONGS_TO_DOMAIN**: Experiment → Domain
- **WORKS_WITH_DATASET**: Experiment → Dataset

#### Learning Relationships
- **LEARNS_FROM**: Experiment → FailurePattern (learns from failure)
- **VALIDATES**: Experiment → Assumption (confirms assumption)
- **REFUTES**: Experiment → Assumption (disproves assumption)  
- **SUPPORTS**: Experiment → Hypothesis (evidence for)
- **CONTRADICTS**: Experiment → Hypothesis (evidence against)

#### Semantic Relationships
- **REQUIRES**: Technique → Concept (prerequisites)
- **IMPLIES**: Insight → Concept (logical connection)
- **CONFLICTS_WITH**: Assumption ↔ Assumption (contradictory)
- **GENERALIZES**: Pattern → Pattern (more general case)
- **SPECIALIZES**: Pattern → Pattern (more specific case)

### Example Schema in Cypher

```cypher
// Core nodes
CREATE (exp:DSAssistExperiment {id: "exp-1", research_question: "Analyze correlation"})
CREATE (iter:DSAssistIteration {experiment_id: "exp-1", iteration: 1, success: true})
CREATE (plan:DSAssistPlan {experiment_id: "exp-1", tasks: ["load_data", "compute_correlation"]})
CREATE (eval:DSAssistEvaluation {iteration_id: "iter-1", score: 0.85})

// Knowledge artifacts
CREATE (code:CodePattern {name: "correlation_analysis", template: "cor(x, y)"})
CREATE (data:DataPattern {name: "outlier_removal", description: "Remove outliers before correlation"})
CREATE (metric:MetricPattern {name: "pearson_correlation", formula: "cor(x, y, method='pearson')"})
CREATE (failure:FailurePattern {name: "linear_on_nonlinear", description: "Using linear correlation on nonlinear data"})

// Domain knowledge
CREATE (domain:Domain {name: "correlation_analysis"})
CREATE (technique:Technique {name: "pearson_correlation"})
CREATE (concept:Concept {name: "statistical_significance"})

// Relationships
CREATE (exp)-[:HAS_ITERATION]->(iter)
CREATE (exp)-[:HAS_PLAN]->(plan)
CREATE (iter)-[:HAS_EVALUATION]->(eval)
CREATE (iter)-[:USES_PATTERN]->(code)
CREATE (iter)-[:APPLIES_TECHNIQUE]->(technique)
CREATE (exp)-[:BELONGS_TO_DOMAIN]->(domain)
```

## Benefits of Rich Ontology

### 1. Enhanced Pattern Recognition
- Find code patterns that work for specific problem types
- Identify failure patterns to avoid
- Discover technique combinations that work well together

### 2. Sophisticated Similarity Matching
- Match experiments by domain, technique, data characteristics
- Find conceptually similar problems, not just text similarity
- Identify transfer learning opportunities across domains

### 3. Causal Knowledge Representation
- Track which techniques lead to which outcomes
- Model prerequisite relationships between concepts
- Represent logical implications and contradictions

### 4. Meta-Learning Capabilities
- Learn which planning strategies work for which problem types
- Understand evaluation criteria for different domains
- Develop domain-specific best practices

### 5. Failure Analysis
- Systematic tracking of what doesn't work
- Pattern recognition in failure modes
- Proactive failure prevention

## Query Examples

### Find Successful Patterns for Domain
```cypher
MATCH (exp:DSAssistExperiment)-[:BELONGS_TO_DOMAIN]->(d:Domain {name: "time_series"})
MATCH (exp)-[:HAS_ITERATION]->(iter:DSAssistIteration {success: true})
MATCH (iter)-[:USES_PATTERN]->(pattern)
RETURN pattern.name, count(*) as usage_count
ORDER BY usage_count DESC
```

### Find Prerequisites for Technique
```cypher
MATCH (t:Technique {name: "linear_regression"})-[:REQUIRES]->(concept:Concept)
RETURN concept.name as prerequisite
```

### Find Contradictory Assumptions
```cypher
MATCH (a1:Assumption)-[:CONFLICTS_WITH]->(a2:Assumption)
WHERE a1.domain = "machine_learning"
RETURN a1.statement, a2.statement
```

### Transfer Learning Opportunities
```cypher
MATCH (exp1:DSAssistExperiment)-[:BELONGS_TO_DOMAIN]->(d1:Domain)
MATCH (exp2:DSAssistExperiment)-[:BELONGS_TO_DOMAIN]->(d2:Domain)
MATCH (exp1)-[:HAS_ITERATION]->(iter1)-[:USES_PATTERN]->(pattern)
MATCH (exp2)-[:HAS_ITERATION]->(iter2)-[:USES_PATTERN]->(pattern)
WHERE d1 <> d2 AND iter1.success = true AND iter2.success = true
RETURN d1.name, d2.name, pattern.name, count(*) as cross_domain_usage
```

## Implementation Priority

### Phase 1: Core Relationships (Immediate)
- BUILDS_ON, SIMILAR_TO, IMPROVES (experiment lineage)
- USES_PATTERN, APPLIES_TECHNIQUE (technique tracking)
- HAS_PLAN, HAS_EVALUATION (workflow tracking)

### Phase 2: Knowledge Patterns (Near-term)
- CodePattern, DataPattern, MetricPattern nodes
- DISCOVERS_PATTERN, LEARNS_FROM relationships
- Domain and Technique classification

### Phase 3: Advanced Semantics (Long-term)  
- Concept and Assumption modeling
- Logical relationships (REQUIRES, IMPLIES, CONFLICTS_WITH)
- Hypothesis tracking and validation

### Phase 4: Meta-Learning (Future)
- Planning strategy patterns
- Agent behavior optimization
- Cross-domain transfer learning

This rich ontology would transform the knowledge graph from a simple experiment log into a true AI-powered research assistant that accumulates and applies scientific knowledge.