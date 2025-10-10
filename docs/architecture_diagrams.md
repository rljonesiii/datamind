# DSAssist Architecture Diagrams

This document contains comprehensive Mermaid diagrams illustrating the DSAssist system architecture, agent interactions, and data flows with **ChromaDB Vector Database Integration** and **Enhanced Workflow Foundation**.

> **Note on Vector Database Strategy**: ChromaDB with Python servers is currently used as a **development solution only** due to limited scaling capabilities. Production deployments will transition to [SemaDbAPI.jl](https://github.com/imohag9/SemaDbAPI.jl) for better performance and scaling in Julia-native environments.

**Layout Configuration**: These diagrams use adaptive layout with flexible positioning for optimal readability across different screen sizes and viewing contexts.

## 1. Enhanced System Architecture with Vector Database

```mermaid
%%{init: {"flowchart": {"htmlLabels": true, "curve": "basis", "useMaxWidth": true}, "layout": "dagre"}}%%
graph LR
    subgraph "User Interface"
        UI["User Research Question"]
        CLI["Command Line Interface<br/>Real/Demo Mode Support"]
        PLUTO["Pluto.jl Notebooks<br/>Interactive Analysis"]
        SCRIPTS["Enhanced Scripts<br/>Vector Database Enabled"]
    end
  
    subgraph "Enhanced Workflow Foundation"
        EWF["Enhanced Workflow Foundation<br/>Shared Module Architecture"]
        CREATE["create_enhanced_experiment()<br/>Vector Database Integration"]
        RUN["run_enhanced_workflow()<br/>Semantic Capabilities"]
        INSIGHTS["get_semantic_insights()<br/>Cross-Domain Learning"]
    end
  
    subgraph "Core System"
        MC["Meta-Controller<br/>Orchestration & State Management"]
      
        subgraph "Agent Layer"
            PA["Planning Agent<br/>Chain-of-Thought Reasoning"]
            CGA["Code Generation Agent<br/>Julia/Python Code Synthesis"]
            EA["Evaluation Agent<br/>Result Analysis & Metrics"]
            RA["Reflection Agent<br/>Knowledge Integration"]
        end
      
        subgraph "Execution Environment"
            SB["Sandboxed Execution<br/>Resource-Limited Container"]
            JML["Julia Native ML Pipeline<br/>5-100x Performance Boost"]
            PLOT["Interactive Plotting<br/>Pluto.jl & PlotlyJS"]
        end
      
        subgraph "Enhanced Knowledge Management"
            EKG["Enhanced Knowledge Graph<br/>Vector Database Support"]
            CHROMADB["ChromaDB Vector Database<br/>Persistent Storage (Dev Only)"]
            NEO4J_KG["Neo4j Graph Database<br/>Relationship Tracking"]
            PROV["Provenance Tracking<br/>Experiment Lineage"]
            PATTERNS["Pattern Recognition<br/>Semantic Similarity"]
        end
      
        subgraph "Infrastructure"
            LLM["LLM Client<br/>Real/Mock API Support"]
            CONFIG["Configuration<br/>DSASSIST_USE_REAL_API"]
            MSG["Message Bus<br/>Agent Communication"]
            PYTHON_BRIDGE["PyCall Bridge<br/>Python Integration"]
        end
    end
  
    subgraph "Vector Database Layer"
        PERSISTENT["PersistentClient<br/>~/.dsassist/chromadb/<br/>(Dev Storage)"]
        COLLECTIONS["Collections<br/>research_questions, code_patterns,<br/>experiment_results, agent_communications"]
        EMBEDDINGS["Embedding System<br/>128-dimension vectors"]
        SEMANTIC["Semantic Search<br/>30-41% similarity matching"]
    end
  
    subgraph "External Services"
        OPENAI["OpenAI API<br/>GPT-4/GPT-3.5<br/>Real Mode"]
        MOCK["Mock Response System<br/>Demo Mode"]
        NEO4J["Neo4j Database<br/>Optional Graph Storage"]
        FS["File System<br/>Data & Artifacts"]
        PYTHON_ENV["Python Virtual Environment<br/>ChromaDB Dependencies (Dev Only)"]
    end
  
    %% User Interface Connections
    UI --> EWF
    CLI --> EWF
    PLUTO --> EWF
    SCRIPTS --> EWF
  
    %% Enhanced Workflow Foundation
    EWF --> CREATE
    EWF --> RUN
    EWF --> INSIGHTS
    CREATE --> MC
    RUN --> MC
    INSIGHTS --> EKG
  
    %% Core System Connections
    MC --> PA
    MC --> CGA
    MC --> EA
    MC --> RA
    MC --> MSG
  
    PA --> CGA
    CGA --> SB
    SB --> EA
    EA --> RA
    RA --> EKG
  
    %% Execution Environment
    SB --> JML
    SB --> PLOT
    JML --> SB
    PLOT --> SB
  
    %% Enhanced Knowledge Management
    EKG --> CHROMADB
    EKG --> NEO4J_KG
    EKG --> PROV
    EKG --> PATTERNS
    CHROMADB --> PERSISTENT
    CHROMADB --> COLLECTIONS
    CHROMADB --> EMBEDDINGS
    CHROMADB --> SEMANTIC
    PATTERNS --> CGA
    PROV --> EA
  
    %% Infrastructure
    PA --> LLM
    CGA --> LLM
    EA --> LLM
    CONFIG --> LLM
    LLM --> OPENAI
    LLM --> MOCK
    PYTHON_BRIDGE --> CHROMADB
    PYTHON_BRIDGE --> PYTHON_ENV
  
    %% External Services
    MC --> CONFIG
    MSG --> PA
    MSG --> CGA
    MSG --> EA
    MSG --> RA
    NEO4J_KG --> NEO4J
    SB --> FS
    MC --> FS
  
    %% Styling
    classDef userInterface fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef enhanced fill:#e8f5e8,stroke:#2e7d32,stroke-width:3px
    classDef agent fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef execution fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef knowledge fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    classDef vector fill:#f1f8e9,stroke:#689f38,stroke-width:3px
    classDef infrastructure fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    classDef external fill:#f1f8e9,stroke:#558b2f,stroke-width:2px
  
    class UI,CLI,PLUTO,SCRIPTS userInterface
    class EWF,CREATE,RUN,INSIGHTS enhanced
    class PA,CGA,EA,RA agent
    class SB,JML,PLOT execution
    class EKG,CHROMADB,NEO4J_KG,PROV,PATTERNS knowledge
    class PERSISTENT,COLLECTIONS,EMBEDDINGS,SEMANTIC vector
    class LLM,CONFIG,MSG,PYTHON_BRIDGE infrastructure
    class OPENAI,MOCK,NEO4J,FS,PYTHON_ENV external
```

## 2. Enhanced Agent Communication Flow with Vector Database

```mermaid
sequenceDiagram
    participant User
    participant EWF as Enhanced Workflow Foundation
    participant MC as Meta-Controller
    participant PA as Planning Agent
    participant CGA as Code Gen Agent
    participant SB as Sandbox
    participant EA as Evaluation Agent
    participant RA as Reflection Agent
    participant EKG as Enhanced Knowledge Graph
    participant VDB as ChromaDB Vector Database (Dev)
    participant LLM as LLM Client (Real/Mock)
  
    User->>EWF: Research Question
    EWF->>EWF: create_enhanced_experiment()
    EWF->>MC: Initialize Enhanced Controller
    MC->>MC: Configure Real/Demo Mode
    MC->>EKG: Initialize Enhanced Knowledge Graph
    EKG->>VDB: Load Persistent ChromaDB Collections
    VDB-->>EKG: Collections Ready (research_questions, code_patterns, etc.)
  
    loop Enhanced Experiment Iteration
        EWF->>MC: run_enhanced_workflow()
        MC->>PA: Enhanced Plan Request with Semantic Context
        PA->>EKG: Query Similar Research Patterns
        EKG->>VDB: Semantic Similarity Search
        VDB-->>EKG: Top-K Similar Experiments (30-41% similarity)
        EKG-->>PA: Historical Context + Semantic Insights
        PA->>PA: Generate Enhanced Plan with Vector Context
        PA->>LLM: Request LLM Analysis (Real API or Mock)
        LLM-->>PA: Strategic Response
        PA-->>MC: Structured Plan with Semantic Enrichment
      
        MC->>CGA: Enhanced Code Generation Request
        CGA->>EKG: Query Successful Code Patterns
        EKG->>VDB: Search Code Pattern Embeddings
        VDB-->>EKG: Relevant Code Templates
        EKG-->>CGA: Context-Aware Code Patterns
        CGA->>CGA: Generate Julia Code with Pattern Matching
        CGA->>LLM: Code Generation Request (Real/Mock Mode)
        LLM-->>CGA: Generated Code Response
        CGA-->>MC: Executable Code with Vector Intelligence
      
        MC->>SB: Execute Enhanced Code
        SB->>SB: Run in Sandboxed Environment
        SB-->>MC: Execution Results + Metadata
      
        MC->>EA: Evaluate Enhanced Results
        EA->>EA: Analyze Metrics & Output with Historical Context
        EA->>LLM: Evaluation Request (Real/Mock Mode)
        LLM-->>EA: Evaluation Analysis
        EA-->>MC: Evaluation Summary with Semantic Scoring
      
        alt Continue Experiment
            MC->>RA: Reflect on Iteration with Vector Context
            RA->>EKG: Update Knowledge with Semantic Embeddings
            EKG->>VDB: Store New Embeddings (experiment_results, agent_communications)
            VDB-->>EKG: Persistent Storage Confirmed
            RA->>EKG: Cross-Domain Pattern Discovery
            EKG->>VDB: Query Cross-Domain Insights
            VDB-->>EKG: Related Patterns from Other Domains
            EKG-->>RA: Enhanced Pattern Recognition
            RA-->>MC: Next Iteration Plan with Vector Intelligence
        else Complete Experiment
            EWF->>EWF: get_semantic_insights()
            EWF->>VDB: Final Semantic Analysis
            VDB-->>EWF: Comprehensive Insights
            MC->>User: Final Results + Semantic Discovery Report
        end
    end
  
    Note over User,VDB: Enhanced workflow provides semantic understanding,<br/>cross-domain learning, and intelligent agent coordination<br/>through persistent ChromaDB vector database integration
```

## 3. ChromaDB Vector Database Architecture (Development Environment)

> **Development Note**: This ChromaDB implementation serves as the current development solution. Production systems will migrate to [SemaDbAPI.jl](https://github.com/imohag9/SemaDbAPI.jl) for enhanced performance and scaling in Julia-native environments.

```mermaid
%%{init: {"flowchart": {"htmlLabels": true, "curve": "cardinal", "useMaxWidth": true}, "layout": "elk"}}%%
graph LR
    subgraph "Julia Integration Layer"
        PYCALL["PyCall.jl Bridge<br/>Python Integration"]
        VDB_INTERFACE["VectorDB Interface<br/>src/knowledge/vector_db.jl"]
        FALLBACK["Graceful Fallback<br/>InMemoryVectorDB"]
    end
  
    subgraph "ChromaDB Python Layer (Development)"
        CHROMADB["ChromaDB 1.1.1<br/>Python Vector Database<br/>(Dev Environment Only)"]
        PERSISTENT_CLIENT["PersistentClient<br/>Local Storage Backend"]
        EMBEDDING_ENGINE["Embedding Engine<br/>128-dimension vectors"]
    end
  
    subgraph "Production Alternative"
        SEMADB["SemaDbAPI.jl<br/>Julia-Native Vector Database<br/>(Production Ready)"]
        JULIA_CLIENT["Native Julia Client<br/>Direct Integration"]
        SCALING_ENGINE["Optimized Scaling<br/>Enterprise Performance"]
    end
  
    subgraph "Persistent Storage (Development Only)"
        STORAGE_PATH["~/.dsassist/chromadb/<br/>Local Storage Directory<br/>(Dev Environment)"]
        
        subgraph "Collections (4 Active)"
            RESEARCH_COLLECTION["research_questions<br/>Research Query Embeddings"]
            CODE_COLLECTION["code_patterns<br/>Code Template Embeddings"] 
            RESULTS_COLLECTION["experiment_results<br/>Outcome Embeddings"]
            COMM_COLLECTION["agent_communications<br/>Agent Message Embeddings"]
        end
        
        subgraph "Storage Files (17 files, 440+ KB)"
            METADATA["Metadata Files<br/>Collection Schemas"]
            VECTORS["Vector Data<br/>Embedding Storage"]
            INDICES["Search Indices<br/>Performance Optimization"]
        end
    end
  
    subgraph "Semantic Operations"
        SIMILARITY_SEARCH["semantic_similarity_search()<br/>Top-K Similar Items"]
        CROSS_DOMAIN["Cross-Domain Learning<br/>Pattern Recognition Across Fields"]
        INTELLIGENT_COORD["Intelligent Coordination<br/>Context-Aware Agent Planning"]
        CONTINUOUS_LEARN["Continuous Learning<br/>Persistent Knowledge Accumulation"]
    end
  
    subgraph "Enhanced Workflow Integration"
        EWF_INTEGRATION["Enhanced Workflow Foundation<br/>Vector-Enabled Scripts"]
        EXPERIMENT_CREATION["create_enhanced_experiment()<br/>Semantic Context Injection"]
        WORKFLOW_EXECUTION["run_enhanced_workflow()<br/>Vector-Guided Processing"]
        INSIGHTS_EXTRACTION["get_semantic_insights()<br/>Cross-Domain Discovery"]
    end
  
    subgraph "Performance & Reliability"
        MATRIX_ACCESS["Matrix Access Patterns<br/>ChromaDB 1.1+ Compatibility"]
        ERROR_HANDLING["Robust Error Handling<br/>Graceful Degradation"]
        PERSISTENCE["Session Persistence<br/>Data Survives Restarts"]
        SIMILARITY_SCORING["30-41% Similarity Matching<br/>Meaningful Results"]
    end
  
    %% Integration Connections
    VDB_INTERFACE --> PYCALL
    PYCALL --> CHROMADB
    VDB_INTERFACE --> FALLBACK
    
    %% ChromaDB Connections
    CHROMADB --> PERSISTENT_CLIENT
    CHROMADB --> EMBEDDING_ENGINE
    PERSISTENT_CLIENT --> STORAGE_PATH
    
    %% Storage Connections
    STORAGE_PATH --> RESEARCH_COLLECTION
    STORAGE_PATH --> CODE_COLLECTION
    STORAGE_PATH --> RESULTS_COLLECTION
    STORAGE_PATH --> COMM_COLLECTION
    
    RESEARCH_COLLECTION --> METADATA
    CODE_COLLECTION --> VECTORS
    RESULTS_COLLECTION --> INDICES
    COMM_COLLECTION --> VECTORS
    
    %% Semantic Operations
    CHROMADB --> SIMILARITY_SEARCH
    SIMILARITY_SEARCH --> CROSS_DOMAIN
    CROSS_DOMAIN --> INTELLIGENT_COORD
    INTELLIGENT_COORD --> CONTINUOUS_LEARN
    
    %% Enhanced Workflow Integration
    VDB_INTERFACE --> EWF_INTEGRATION
    EWF_INTEGRATION --> EXPERIMENT_CREATION
    EWF_INTEGRATION --> WORKFLOW_EXECUTION
    EWF_INTEGRATION --> INSIGHTS_EXTRACTION
    
    EXPERIMENT_CREATION --> SIMILARITY_SEARCH
    WORKFLOW_EXECUTION --> CROSS_DOMAIN
    INSIGHTS_EXTRACTION --> INTELLIGENT_COORD
    
    %% Performance Features
    CHROMADB --> MATRIX_ACCESS
    VDB_INTERFACE --> ERROR_HANDLING
    PERSISTENT_CLIENT --> PERSISTENCE
    SIMILARITY_SEARCH --> SIMILARITY_SCORING
    
    %% Styling
    classDef integration fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef chromadb fill:#f1f8e9,stroke:#689f38,stroke-width:2px
    classDef storage fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef collections fill:#fce4ec,stroke:#e91e63,stroke-width:2px
    classDef files fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px
    classDef semantic fill:#e8f5e8,stroke:#4caf50,stroke-width:2px
    classDef enhanced fill:#fff8e1,stroke:#fbc02d,stroke-width:3px
    classDef performance fill:#ffebee,stroke:#d32f2f,stroke-width:2px
  
    class PYCALL,VDB_INTERFACE,FALLBACK integration
    class CHROMADB,PERSISTENT_CLIENT,EMBEDDING_ENGINE chromadb
    class STORAGE_PATH storage
    class RESEARCH_COLLECTION,CODE_COLLECTION,RESULTS_COLLECTION,COMM_COLLECTION collections
    class METADATA,VECTORS,INDICES files
    class SIMILARITY_SEARCH,CROSS_DOMAIN,INTELLIGENT_COORD,CONTINUOUS_LEARN semantic
    class EWF_INTEGRATION,EXPERIMENT_CREATION,WORKFLOW_EXECUTION,INSIGHTS_EXTRACTION enhanced
    class MATRIX_ACCESS,ERROR_HANDLING,PERSISTENCE,SIMILARITY_SCORING performance
```

**Production Scaling Note**: ChromaDB with Python servers is used as a development solution only due to limited scaling capabilities. Production deployments will transition to [SemaDbAPI.jl](https://github.com/imohag9/SemaDbAPI.jl) for better performance and enterprise-grade scaling in the Julia ecosystem.

## 4. Julia Native ML Pipeline Architecture

```mermaid
%%{init: {"flowchart": {"htmlLabels": true, "curve": "cardinal", "useMaxWidth": true}, "layout": "elk"}}%%
graph LR
    subgraph "Data Input Layer"
        CSV["CSV Files"]
        JSON["JSON Data"]
        API["External APIs"]
        DB["Databases"]
    end
  
    subgraph "Julia Native ML Pipeline"
        LOAD["load_and_prepare_data<br/>Enhanced Data Loading"]
        VALID["validate_data_quality<br/>Missing Values & Duplicates"]
      
        subgraph "Data Processing"
            ENCODE["encode_categorical_features<br/>Robust Encoding"]
            STANDARD["standardize_features<br/>Z-score & MinMax"]
            OUTLIER["detect_outliers<br/>IQR & Z-score Methods"]
        end
      
        subgraph "Model Training"
            SPLIT["train_test_split_julia<br/>Stratified Sampling"]
            CV["cross_validate_model<br/>K-fold Validation"]
            TRAIN["linear_regression_analysis<br/>GLM.jl Integration"]
        end
      
        subgraph "Advanced Analytics"
            BOOTSTRAP["bootstrap_confidence_intervals<br/>Uncertainty Quantification"]
            FEATURE["feature_importance_analysis<br/>Model Interpretability"]
            ENSEMBLE["ensemble_methods<br/>Bootstrap Aggregation"]
        end
    end
  
    subgraph "Performance Benefits"
        SPEED["5-100x Faster<br/>vs Python/sklearn"]
        MEMORY["Memory Efficient<br/>Chunked Processing"]
        TYPE["Type-Safe<br/>Compile-time Optimization"]
    end
  
    subgraph "Output Layer"
        METRICS["Model Metrics<br/>R2, RMSE, Confidence"]
        PLOTS["Visualizations<br/>Interactive Plots"]
        REPORTS["Analysis Reports<br/>Business Insights"]
        MODELS["Trained Models<br/>Serialized Objects"]
    end
  
    CSV --> LOAD
    JSON --> LOAD
    API --> LOAD
    DB --> LOAD
  
    LOAD --> VALID
    VALID --> ENCODE
    ENCODE --> STANDARD
    STANDARD --> OUTLIER
  
    OUTLIER --> SPLIT
    SPLIT --> CV
    CV --> TRAIN
  
    TRAIN --> BOOTSTRAP
    BOOTSTRAP --> FEATURE
    FEATURE --> ENSEMBLE
  
    TRAIN --> SPEED
    STANDARD --> MEMORY
    ENCODE --> TYPE
  
    ENSEMBLE --> METRICS
    FEATURE --> PLOTS
    BOOTSTRAP --> REPORTS
    TRAIN --> MODELS
  
    classDef input fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef processing fill:#f1f8e9,stroke:#689f38,stroke-width:2px
    classDef training fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef advanced fill:#fce4ec,stroke:#e91e63,stroke-width:2px
    classDef performance fill:#e8f5e8,stroke:#4caf50,stroke-width:2px
    classDef output fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px
  
    class CSV,JSON,API,DB input
    class LOAD,VALID,ENCODE,STANDARD,OUTLIER processing
    class SPLIT,CV,TRAIN training
    class BOOTSTRAP,FEATURE,ENSEMBLE advanced
    class SPEED,MEMORY,TYPE performance
    class METRICS,PLOTS,REPORTS,MODELS output
```

## 5. Interactive Plotting Architecture

```mermaid
%%{init: {"flowchart": {"htmlLabels": true, "curve": "cardinal", "useMaxWidth": true}, "layout": "elk"}}%%
graph LR
    subgraph "Data Sources"
        DATA["Analysis Data<br/>DataFrames & Arrays"]
        MODELS["Model Results<br/>Metrics & Predictions"]
        METRICS["Business Metrics<br/>KPIs & Statistics"]
    end
    
    subgraph "Pluto.jl Interactive Environment"
        NOTEBOOK["Pluto Notebook<br/>Reactive Computing"]
        UI["PlutoUI Controls<br/>Sliders & Selectors"]
        
        subgraph "Plot Generation"
            PLOTS["Plots.jl<br/>Multi-backend System"]
            PLOTLY["PlotlyJS Backend<br/>Interactive Features"]
            GR["GR Backend<br/>Performance Rendering"]
            STATS["StatsPlots<br/>Statistical Visualizations"]
        end
        
        subgraph "Dashboard Components"
            RISK["Risk Assessment<br/>Dynamic Thresholds"]
            VALUE["Customer Analysis<br/>Segmentation Plots"]
            TREND["Trend Analysis<br/>Time Series Plots"]
            DIST["Distribution Analysis<br/>Histograms & Box Plots"]
        end
    end
    
    subgraph "Output Formats"
        INTERACTIVE["Interactive HTML<br/>PlotlyJS Widgets"]
        STATIC["Static Images<br/>PNG, SVG Export"]
        DASHBOARD["Executive Dashboard<br/>Business Reports"]
        EMBED["Embedded Plots<br/>Notebook Integration"]
    end
    
    subgraph "User Interaction"
        PARAMS["Parameter Control<br/>Real-time Updates"]
        ZOOM["Zoom & Pan<br/>Interactive Exploration"]
        FILTER["Data Filtering<br/>Dynamic Queries"]
        EXPORT["Export Options<br/>Multiple Formats"]
    end
    
    %% Data flow connections
    DATA --> NOTEBOOK
    MODELS --> NOTEBOOK
    METRICS --> NOTEBOOK
    
    NOTEBOOK --> UI
    UI --> PLOTS
    PLOTS --> PLOTLY
    PLOTS --> GR
    PLOTS --> STATS
    
    PLOTLY --> RISK
    PLOTLY --> VALUE
    PLOTLY --> TREND
    PLOTLY --> DIST
    
    RISK --> INTERACTIVE
    VALUE --> INTERACTIVE
    TREND --> STATIC
    DIST --> DASHBOARD
    
    INTERACTIVE --> EMBED
    STATIC --> EMBED
    DASHBOARD --> EMBED
    
    UI --> PARAMS
    PLOTLY --> ZOOM
    NOTEBOOK --> FILTER
    EMBED --> EXPORT
    
    %% Styling
    classDef dataSource fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef environment fill:#f1f8e9,stroke:#689f38,stroke-width:2px
    classDef plotting fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef dashboard fill:#fce4ec,stroke:#e91e63,stroke-width:2px
    classDef output fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px
    classDef interaction fill:#e8f5e8,stroke:#4caf50,stroke-width:2px
    
    class DATA,MODELS,METRICS dataSource
    class NOTEBOOK,UI environment
    class PLOTS,PLOTLY,GR,STATS plotting
    class RISK,VALUE,TREND,DIST dashboard
    class INTERACTIVE,STATIC,DASHBOARD,EMBED output
    class PARAMS,ZOOM,FILTER,EXPORT interaction
```

## 6. Enhanced Knowledge Graph & Provenance Architecture

```mermaid
%%{init: {"flowchart": {"htmlLabels": true, "curve": "cardinal", "useMaxWidth": true}, "layout": "elk"}}%%
graph LR
    subgraph "Experiment Tracking"
        PROMPT["Prompt History<br/>Research Questions"]
        CODE["Code Versions<br/>Generated Scripts"]
        EXEC["Execution Metrics<br/>Performance Data"]
        RESULTS["Results Archive<br/>Outputs & Artifacts"]
    end
    
    subgraph "Enhanced Knowledge Graph"
        EKG["Enhanced Knowledge Graph<br/>Vector Database Integration"]
        
        subgraph "Dual Storage Backend"
            NEO4J["Neo4j / Memgraph<br/>Graph Relationships"]
            CHROMADB_KG["ChromaDB Integration<br/>Semantic Embeddings"]
        end
        
        subgraph "Enhanced Node Types"
            EXP_NODE["Experiment Nodes<br/>Semantic Embeddings"]
            AGENT_NODE["Agent Nodes<br/>Behavior Patterns"]
            DATA_NODE["Data Nodes<br/>Source Embeddings"]
            MODEL_NODE["Model Nodes<br/>Algorithm Patterns"]
            PATTERN_NODE["Pattern Nodes<br/>Cross-Domain Insights"]
        end
        
        subgraph "Enhanced Relationships"
            GENERATED["GENERATED_BY<br/>Agent to Code + Similarity"]
            USED["USED_DATA<br/>Code to Data + Context"]
            PRODUCED["PRODUCED_RESULT<br/>Code to Output + Metrics"]
            IMPROVED["IMPROVED_ON<br/>Result to Result + Score"]
            SIMILAR["SEMANTICALLY_SIMILAR<br/>Vector Distance"]
        end
    end
    
    subgraph "Enhanced Provenance Queries"
        LINEAGE["Experiment Lineage<br/>Full History + Semantic Context"]
        IMPACT["Feature Impact<br/>Accuracy + Similarity Analysis"]
        PATTERNS["Success Patterns<br/>Cross-Domain Meta-Learning"]
        REPRODUCE["Reproducibility<br/>Exact + Semantic Replication"]
        DISCOVER["Pattern Discovery<br/>Automatic Insight Generation"]
    end
    
    subgraph "Vector-Enhanced State Management"
        CONTEXT["Context Preservation<br/>Variable States + Embeddings"]
        IMPORTS["Import History<br/>Dependency + Usage Patterns"]
        ARTIFACTS["Artifact Storage<br/>Plots + Models + Metadata"]
        METADATA["Enhanced Metadata<br/>Timestamps + Semantic Tags"]
        SEMANTIC_STATE["Semantic State<br/>Vector Representations"]
    end
    
    %% Data flow connections
    PROMPT --> EKG
    CODE --> EKG
    EXEC --> EKG
    RESULTS --> EKG
    
    EKG --> NEO4J
    EKG --> CHROMADB_KG
    
    NEO4J --> EXP_NODE
    NEO4J --> AGENT_NODE
    NEO4J --> DATA_NODE
    NEO4J --> MODEL_NODE
    CHROMADB_KG --> PATTERN_NODE
    
    EXP_NODE --> GENERATED
    AGENT_NODE --> GENERATED
    DATA_NODE --> USED
    MODEL_NODE --> PRODUCED
    PATTERN_NODE --> SIMILAR
    
    GENERATED --> LINEAGE
    USED --> IMPACT
    PRODUCED --> PATTERNS
    IMPROVED --> REPRODUCE
    SIMILAR --> DISCOVER
    
    LINEAGE --> CONTEXT
    IMPACT --> IMPORTS
    PATTERNS --> ARTIFACTS
    REPRODUCE --> METADATA
    DISCOVER --> SEMANTIC_STATE
    
    CONTEXT --> EXEC
    IMPORTS --> CODE
    ARTIFACTS --> RESULTS
    METADATA --> PROMPT
    SEMANTIC_STATE --> EKG
    
    %% Styling
    classDef tracking fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef enhanced fill:#e8f5e8,stroke:#2e7d32,stroke-width:3px
    classDef storage fill:#f1f8e9,stroke:#689f38,stroke-width:2px
    classDef nodes fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef relationships fill:#fce4ec,stroke:#e91e63,stroke-width:2px
    classDef queries fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px
    classDef state fill:#fff8e1,stroke:#fbc02d,stroke-width:2px
    
    class PROMPT,CODE,EXEC,RESULTS tracking
    class EKG enhanced
    class NEO4J,CHROMADB_KG storage
    class EXP_NODE,AGENT_NODE,DATA_NODE,MODEL_NODE,PATTERN_NODE nodes
    class GENERATED,USED,PRODUCED,IMPROVED,SIMILAR relationships
    class LINEAGE,IMPACT,PATTERNS,REPRODUCE,DISCOVER queries
    class CONTEXT,IMPORTS,ARTIFACTS,METADATA,SEMANTIC_STATE state
```

## 7. Enhanced Deployment Architecture

```mermaid
%%{init: {"flowchart": {"htmlLabels": true, "curve": "cardinal", "useMaxWidth": true}, "layout": "elk"}}%%
graph LR
    subgraph "Development Environment"
        VSCODE["VS Code<br/>Development IDE + Copilot"]
        PLUTO["Pluto.jl<br/>Interactive Notebooks"]
        REPL["Julia REPL<br/>Testing Environment"]
        GIT["Git Repository<br/>Version Control + GitHub"]
        PYTHON_DEV["Python Virtual Environment<br/>ChromaDB Development Only"]
    end
    
    subgraph "Enhanced Agent Services"
        ORCHESTRATOR["Ray Serve<br/>Enhanced Agent Orchestration"]
        
        subgraph "Enhanced Agent Containers"
            META["Meta-Controller<br/>Vector-Enhanced Pod"]
            PLAN["Planning Agent<br/>Semantic-Aware Pod"]
            CODE["Code-Gen Agent<br/>Pattern-Matching Pod"]
            EVAL["Evaluation Agent<br/>Context-Aware Pod"]
        end
        
        subgraph "Enhanced Execution Environment"
            JULIA_WORKER["Julia Workers<br/>Native ML Processing + ChromaDB"]
            PLUTO_SERVER["Pluto Server<br/>Interactive Notebook Hosting"]
            ARTIFACT_STORE["Enhanced Artifact Storage<br/>S3 + Vector Metadata"]
            PYTHON_RUNTIME["Python Runtime<br/>ChromaDB Service Layer"]
        end
    end
    
    subgraph "Enhanced Data Infrastructure"
        VECTOR_CLUSTER["ChromaDB Cluster<br/>Distributed Vector Storage"]
        GRAPH_DB["Neo4j Cluster<br/>Enhanced Knowledge Graph"]
        MESSAGE_BUS["Redis/RabbitMQ<br/>Vector-Aware Communication"]
        MONITORING["Enhanced Monitoring<br/>Prometheus + Vector Metrics"]
        LOGGING["ELK Stack<br/>Semantic Log Analysis"]
    end
    
    subgraph "External Integrations"
        LLM_API["LLM APIs<br/>OpenAI, Anthropic + Real/Mock Mode"]
        DATA_SOURCES["Enhanced Data Sources<br/>APIs, Databases + Vector Context"]
        NOTIFICATION["Smart Notifications<br/>Slack, Email + Semantic Alerts"]
        BACKUP["Vector-Aware Backup<br/>Long-term Archive + Embeddings"]
    end
    
    subgraph "Enhanced Resource Management"
        SCALING["Vector-Aware Auto-scaling<br/>CPU, Memory + Embedding Load"]
        COST["Enhanced Cost Optimization<br/>Spot Instances + LLM Budget"]
        SECURITY["Enhanced Security<br/>RBAC + Vector Data Encryption"]
        NETWORKING["Vector Load Balancing<br/>Service Mesh + ChromaDB Routing"]
    end
    
    %% Development to Production Flow
    VSCODE --> GIT
    PLUTO --> GIT
    REPL --> GIT
    PYTHON_DEV --> GIT
    GIT --> ORCHESTRATOR
    
    %% Enhanced Agent Orchestration
    ORCHESTRATOR --> META
    ORCHESTRATOR --> PLAN
    ORCHESTRATOR --> CODE
    ORCHESTRATOR --> EVAL
    
    %% Enhanced Agent Communication
    META --> MESSAGE_BUS
    PLAN --> MESSAGE_BUS
    CODE --> MESSAGE_BUS
    EVAL --> MESSAGE_BUS
    
    %% Enhanced Execution Flow
    META --> JULIA_WORKER
    CODE --> JULIA_WORKER
    PLUTO --> PLUTO_SERVER
    JULIA_WORKER --> ARTIFACT_STORE
    JULIA_WORKER --> PYTHON_RUNTIME
    PYTHON_RUNTIME --> VECTOR_CLUSTER
    
    %% Enhanced Data Infrastructure Connections
    ORCHESTRATOR --> VECTOR_CLUSTER
    ORCHESTRATOR --> GRAPH_DB
    JULIA_WORKER --> VECTOR_CLUSTER
    JULIA_WORKER --> GRAPH_DB
    MESSAGE_BUS --> MONITORING
    ARTIFACT_STORE --> LOGGING
    
    %% External Integrations
    PLAN --> LLM_API
    CODE --> LLM_API
    JULIA_WORKER --> DATA_SOURCES
    MONITORING --> NOTIFICATION
    ARTIFACT_STORE --> BACKUP
    
    %% Enhanced Resource Management
    ORCHESTRATOR --> SCALING
    JULIA_WORKER --> COST
    MESSAGE_BUS --> SECURITY
    VECTOR_CLUSTER --> NETWORKING
    GRAPH_DB --> NETWORKING
    
    %% Styling
    classDef development fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef enhanced fill:#e8f5e8,stroke:#2e7d32,stroke-width:3px
    classDef agents fill:#f1f8e9,stroke:#689f38,stroke-width:2px
    classDef containers fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef execution fill:#fce4ec,stroke:#e91e63,stroke-width:2px
    classDef infrastructure fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px
    classDef external fill:#fff8e1,stroke:#fbc02d,stroke-width:2px
    classDef management fill:#ffebee,stroke:#d32f2f,stroke-width:2px
    
    class VSCODE,PLUTO,REPL,GIT,PYTHON_DEV development
    class ORCHESTRATOR enhanced
    class META,PLAN,CODE,EVAL containers
    class JULIA_WORKER,PLUTO_SERVER,ARTIFACT_STORE,PYTHON_RUNTIME execution
    class VECTOR_CLUSTER,GRAPH_DB,MESSAGE_BUS,MONITORING,LOGGING infrastructure
    class LLM_API,DATA_SOURCES,NOTIFICATION,BACKUP external
    class SCALING,COST,SECURITY,NETWORKING management
```

## 8. Enhanced Workflow Foundation Architecture

```mermaid
%%{init: {"flowchart": {"htmlLabels": true, "curve": "cardinal", "useMaxWidth": true}, "layout": "elk"}}%%
graph LR
    subgraph "Enhanced Workflow Scripts"
        CREDIT_CARD["credit_card_guided_tour.jl<br/>Financial Analysis + Vector DB"]
        WEATHER["weather_agentic_analysis.jl<br/>Climate Analysis + Semantic Search"]
        ADVANCED["advanced_agentic_experiments.jl<br/>Research Automation + AI"]
        OTHER_SCRIPTS["Other Enhanced Scripts<br/>Vector-Enabled Workflows"]
    end
    
    subgraph "Enhanced Workflow Foundation Module"
        EWF_MODULE["EnhancedWorkflow Module<br/>scripts/enhanced_workflow_foundation.jl"]
        
        subgraph "Core Functions"
            CREATE_EXP["create_enhanced_experiment()<br/>Vector Context Injection"]
            RUN_WORKFLOW["run_enhanced_workflow()<br/>Semantic-Guided Execution"]
            GET_INSIGHTS["get_semantic_insights()<br/>Cross-Domain Discovery"]
            BANNER["enhanced_workflow_banner()<br/>Consistent UI Experience"]
        end
        
        subgraph "Configuration Management"
            CONFIG_DETECT["Configuration Detection<br/>Real/Demo Mode Selection"]
            API_ROUTING["API Routing Logic<br/>DSASSIST_USE_REAL_API Support"]
            ERROR_HANDLING["Graceful Error Handling<br/>Fallback Mechanisms"]
        end
        
        subgraph "Vector Database Integration"
            VDB_INIT["Vector Database Initialization<br/>ChromaDB Connection"]
            SEMANTIC_DEMO["Semantic Search Demo<br/>Interactive Examples"]
            PATTERN_MATCH["Pattern Matching<br/>Historical Context Retrieval"]
        end
    end
    
    subgraph "DSAssist Core Integration"
        CORE_MODULE["DSAssist Core Module<br/>src/DSAssist.jl"]
        
        subgraph "Enhanced Components"
            ENHANCED_KG["Enhanced Knowledge Graph<br/>Vector + Graph Database"]
            META_CONTROLLER["Enhanced Meta-Controller<br/>Semantic Context Awareness"]
            VECTOR_CLIENT["Vector Database Client<br/>ChromaDB Integration"]
            LLM_CLIENT["Enhanced LLM Client<br/>Real/Mock Response System"]
        end
        
        subgraph "Julia Native ML"
            ML_PIPELINE["Julia Native ML Pipeline<br/>5-100x Performance"]
            DATA_PROCESSING["Enhanced Data Processing<br/>Vector-Aware Operations"]
            MODEL_TRAINING["Optimized Model Training<br/>GLM.jl Integration"]
        end
    end
    
    subgraph "Execution Flow"
        SCRIPT_START["Script Execution Start<br/>Enhanced Banner Display"]
        CONFIG_SETUP["Configuration Setup<br/>Real/Demo Mode Decision"]
        EXPERIMENT_INIT["Experiment Initialization<br/>Vector Context Loading"]
        WORKFLOW_RUN["Workflow Execution<br/>Semantic-Enhanced Processing"]
        RESULTS_ANALYSIS["Results Analysis<br/>Cross-Domain Insights"]
        SEMANTIC_DEMO_RUN["Semantic Demo<br/>Vector Search Examples"]
    end
    
    subgraph "Shared Benefits"
        CONSISTENCY["Consistent Experience<br/>Unified Interface Across Scripts"]
        REUSABILITY["Code Reusability<br/>Shared Foundation Components"]
        MAINTAINABILITY["Easy Maintenance<br/>Single Source of Truth"]
        SCALABILITY["Scalable Architecture<br/>Vector Database Performance"]
    end
    
    %% Script Connections
    CREDIT_CARD --> EWF_MODULE
    WEATHER --> EWF_MODULE
    ADVANCED --> EWF_MODULE
    OTHER_SCRIPTS --> EWF_MODULE
    
    %% Module Internal Connections
    EWF_MODULE --> CREATE_EXP
    EWF_MODULE --> RUN_WORKFLOW
    EWF_MODULE --> GET_INSIGHTS
    EWF_MODULE --> BANNER
    
    EWF_MODULE --> CONFIG_DETECT
    EWF_MODULE --> API_ROUTING
    EWF_MODULE --> ERROR_HANDLING
    
    EWF_MODULE --> VDB_INIT
    EWF_MODULE --> SEMANTIC_DEMO
    EWF_MODULE --> PATTERN_MATCH
    
    %% Core Integration
    EWF_MODULE --> CORE_MODULE
    CORE_MODULE --> ENHANCED_KG
    CORE_MODULE --> META_CONTROLLER
    CORE_MODULE --> VECTOR_CLIENT
    CORE_MODULE --> LLM_CLIENT
    
    CORE_MODULE --> ML_PIPELINE
    CORE_MODULE --> DATA_PROCESSING
    CORE_MODULE --> MODEL_TRAINING
    
    %% Execution Flow
    EWF_MODULE --> SCRIPT_START
    SCRIPT_START --> CONFIG_SETUP
    CONFIG_SETUP --> EXPERIMENT_INIT
    EXPERIMENT_INIT --> WORKFLOW_RUN
    WORKFLOW_RUN --> RESULTS_ANALYSIS
    RESULTS_ANALYSIS --> SEMANTIC_DEMO_RUN
    
    %% Benefits
    EWF_MODULE --> CONSISTENCY
    EWF_MODULE --> REUSABILITY
    EWF_MODULE --> MAINTAINABILITY
    EWF_MODULE --> SCALABILITY
    
    %% Styling
    classDef scripts fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef foundation fill:#e8f5e8,stroke:#2e7d32,stroke-width:3px
    classDef functions fill:#f1f8e9,stroke:#689f38,stroke-width:2px
    classDef config fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef vector fill:#fce4ec,stroke:#e91e63,stroke-width:2px
    classDef core fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px
    classDef enhanced fill:#fff8e1,stroke:#fbc02d,stroke-width:2px
    classDef ml fill:#ffebee,stroke:#d32f2f,stroke-width:2px
    classDef execution fill:#e0f2f1,stroke:#00695c,stroke-width:2px
    classDef benefits fill:#f9fbe7,stroke:#827717,stroke-width:2px
    
    class CREDIT_CARD,WEATHER,ADVANCED,OTHER_SCRIPTS scripts
    class EWF_MODULE foundation
    class CREATE_EXP,RUN_WORKFLOW,GET_INSIGHTS,BANNER functions
    class CONFIG_DETECT,API_ROUTING,ERROR_HANDLING config
    class VDB_INIT,SEMANTIC_DEMO,PATTERN_MATCH vector
    class CORE_MODULE core
    class ENHANCED_KG,META_CONTROLLER,VECTOR_CLIENT,LLM_CLIENT enhanced
    class ML_PIPELINE,DATA_PROCESSING,MODEL_TRAINING ml
    class SCRIPT_START,CONFIG_SETUP,EXPERIMENT_INIT,WORKFLOW_RUN,RESULTS_ANALYSIS,SEMANTIC_DEMO_RUN execution
    class CONSISTENCY,REUSABILITY,MAINTAINABILITY,SCALABILITY benefits
```

## Enhanced Usage Instructions

### Current Architecture Status (October 2025)

The DSAssist system now features a **fully integrated ChromaDB vector database** with **Enhanced Workflow Foundation** providing:

- ✅ **Persistent Vector Storage**: ChromaDB with 17 files (440+ KB) in `~/.dsassist/chromadb/`
- ✅ **Semantic Search**: 30-41% similarity matching for meaningful research insights
- ✅ **Enhanced Workflow Foundation**: Shared module architecture across all scripts
- ✅ **Real/Demo Mode Support**: `DSASSIST_USE_REAL_API` configuration with real API as default
- ✅ **Cross-Domain Learning**: Pattern recognition across different research domains
- ✅ **Julia Native ML**: 5-100x performance improvements over Python/sklearn
- ✅ **Production Ready**: Robust error handling and graceful fallbacks

### Running Enhanced Scripts

**Real Mode (Default):**
```bash
export OPENAI_API_KEY="your-api-key"
julia scripts/credit_card_guided_tour.jl
# → 🤖 REAL AGENTIC MODE: Vector database + live LLM agents
```

**Demo Mode:**
```bash
export DSASSIST_USE_REAL_API=false
julia scripts/weather_agentic_analysis.jl
# → ⚠️ DEMO MODE: Vector database + mock responses
```

### Architecture Highlights

1. **Enhanced System Architecture**: ChromaDB integration with persistent storage
2. **Enhanced Agent Communication**: Semantic context in all agent interactions  
3. **ChromaDB Vector Database**: Dedicated architecture for vector operations
4. **Julia Native ML Pipeline**: Optimized 467-line native ML implementation
5. **Interactive Plotting**: Pluto.jl integration for dynamic visualizations
6. **Enhanced Knowledge Graph**: Dual storage (Neo4j + ChromaDB) with semantic relationships
7. **Enhanced Deployment**: Vector-aware scaling and monitoring
8. **Enhanced Workflow Foundation**: Shared module architecture for consistency

### Embedding in Documentation

To use these diagrams in your documentation, copy the Mermaid code blocks and paste them into any Markdown file. Most modern documentation platforms (GitHub, GitLab, Notion, etc.) support Mermaid rendering.

### Live Editing

You can edit these diagrams using:
- [Mermaid Live Editor](https://mermaid.live/)
- VS Code with Mermaid extension
- GitHub's built-in Mermaid support

### Customization

Each diagram includes CSS classes for styling. You can modify colors and styling by adjusting the `classDef` definitions at the bottom of each diagram.

### Integration with Architecture Documentation

These diagrams complement the existing architecture documentation in:
- `docs/architecture.md` - Detailed technical descriptions
- `docs/configuration.md` - Setup and configuration guides
- `README.md` - High-level overview and quick start
- `docs/chromadb_julia_integration.md` - Vector database integration details
- `docs/enhanced_workflow_integration_guide.md` - Enhanced workflow foundation usage

