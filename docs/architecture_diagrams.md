# DSAssist Architecture Diagrams

This document contains comprehensive Mermaid diagrams illustrating the DSAssist system architecture, agent interactions, and data flows.

**Layout Configuration**: These diagrams use adaptive layout with flexible positioning for optimal readability across different screen sizes and viewing contexts.

## 1. High-Level System Architecture

```mermaid
%%{init: {"flowchart": {"htmlLabels": true, "curve": "basis", "useMaxWidth": true}, "layout": "dagre"}}%%
graph LR
    subgraph "User Interface"
        UI["User Research Question"]
        CLI["Command Line Interface"]
        PLUTO["Pluto.jl Notebooks"]
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
      
        subgraph "Knowledge Management"
            KG["Knowledge Graph<br/>Neo4j/Memgraph"]
            PROV["Provenance Tracking<br/>Experiment Lineage"]
            PATTERNS["Pattern Recognition<br/>Successful Code Templates"]
        end
      
        subgraph "Infrastructure"
            LLM["LLM Client<br/>Cost-Aware Routing"]
            CONFIG["Configuration<br/>YAML/TOML Settings"]
            MSG["Message Bus<br/>Agent Communication"]
        end
    end
  
    subgraph "External Services"
        OPENAI["OpenAI API<br/>GPT-4/GPT-3.5"]
        NEO4J["Neo4j Database<br/>Knowledge Storage"]
        FS["File System<br/>Data & Artifacts"]
    end
  
    UI --> MC
    CLI --> MC
    PLUTO --> MC
  
    MC --> PA
    MC --> CGA
    MC --> EA
    MC --> RA
    MC --> MSG
  
    PA --> CGA
    CGA --> SB
    SB --> EA
    EA --> RA
    RA --> KG
  
    SB --> JML
    SB --> PLOT
    JML --> SB
    PLOT --> SB
  
    KG --> PROV
    KG --> PATTERNS
    PATTERNS --> CGA
    PROV --> EA
  
    PA --> LLM
    CGA --> LLM
    EA --> LLM
    LLM --> OPENAI
  
    MC --> CONFIG
    MSG --> PA
    MSG --> CGA
    MSG --> EA
    MSG --> RA
  
    KG --> NEO4J
    SB --> FS
    MC --> FS
  
    classDef userInterface fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef agent fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef execution fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef knowledge fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    classDef infrastructure fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    classDef external fill:#f1f8e9,stroke:#558b2f,stroke-width:2px
  
    class UI,CLI,PLUTO userInterface
    class PA,CGA,EA,RA agent
    class SB,JML,PLOT execution
    class KG,PROV,PATTERNS knowledge
    class LLM,CONFIG,MSG infrastructure
    class OPENAI,NEO4J,FS external
```

## 2. Agent Communication Flow

```mermaid
sequenceDiagram
    participant User
    participant MC as Meta-Controller
    participant PA as Planning Agent
    participant CGA as Code Gen Agent
    participant SB as Sandbox
    participant EA as Evaluation Agent
    participant RA as Reflection Agent
    participant KG as Knowledge Graph
  
    User->>MC: Research Question
    MC->>MC: Initialize Experiment
  
    loop Experiment Iteration
        MC->>PA: Plan Request
        PA->>KG: Query Similar Patterns
        KG-->>PA: Historical Context
        PA->>PA: Generate Plan
        PA-->>MC: Structured Plan
      
        MC->>CGA: Code Generation Request
        CGA->>KG: Query Code Patterns
        KG-->>CGA: Successful Templates
        CGA->>CGA: Generate Julia Code
        CGA-->>MC: Executable Code
      
        MC->>SB: Execute Code
        SB->>SB: Run in Sandboxed Environment
        SB-->>MC: Execution Results
      
        MC->>EA: Evaluate Results
        EA->>EA: Analyze Metrics & Output
        EA-->>MC: Evaluation Summary
      
        alt Continue Experiment
            MC->>RA: Reflect on Iteration
            RA->>KG: Update Knowledge
            KG-->>RA: Updated Patterns
            RA-->>MC: Next Iteration Plan
        else Complete Experiment
            MC->>User: Final Results
        end
    end
```

## 3. Julia Native ML Pipeline Architecture

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

## 4. Interactive Plotting Architecture

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

## 5. Knowledge Graph & Provenance Architecture

```mermaid
%%{init: {"flowchart": {"htmlLabels": true, "curve": "cardinal", "useMaxWidth": true}, "layout": "elk"}}%%
graph LR
    subgraph "Experiment Tracking"
        PROMPT["Prompt History<br/>Research Questions"]
        CODE["Code Versions<br/>Generated Scripts"]
        EXEC["Execution Metrics<br/>Performance Data"]
        RESULTS["Results Archive<br/>Outputs & Artifacts"]
    end
    
    subgraph "Knowledge Graph Database"
        NEO4J["Neo4j / Memgraph<br/>Graph Database"]
        
        subgraph "Node Types"
            EXP_NODE["Experiment Nodes<br/>Unique Identifiers"]
            AGENT_NODE["Agent Nodes<br/>Type & Configuration"]
            DATA_NODE["Data Nodes<br/>Sources & Transformations"]
            MODEL_NODE["Model Nodes<br/>Algorithms & Parameters"]
        end
        
        subgraph "Relationship Types"
            GENERATED["GENERATED_BY<br/>Agent to Code"]
            USED["USED_DATA<br/>Code to Data"]
            PRODUCED["PRODUCED_RESULT<br/>Code to Output"]
            IMPROVED["IMPROVED_ON<br/>Result to Result"]
        end
    end
    
    subgraph "Provenance Queries"
        LINEAGE["Experiment Lineage<br/>Full History Tracking"]
        IMPACT["Feature Impact<br/>Accuracy Improvements"]
        PATTERNS["Success Patterns<br/>Meta-Learning"]
        REPRODUCE["Reproducibility<br/>Exact Replication"]
    end
    
    subgraph "State Management"
        CONTEXT["Context Preservation<br/>Variable States"]
        IMPORTS["Import History<br/>Dependency Tracking"]
        ARTIFACTS["Artifact Storage<br/>Plots & Models"]
        METADATA["Experiment Metadata<br/>Timestamps & Tags"]
    end
    
    %% Data flow connections
    PROMPT --> NEO4J
    CODE --> NEO4J
    EXEC --> NEO4J
    RESULTS --> NEO4J
    
    NEO4J --> EXP_NODE
    NEO4J --> AGENT_NODE
    NEO4J --> DATA_NODE
    NEO4J --> MODEL_NODE
    
    EXP_NODE --> GENERATED
    AGENT_NODE --> GENERATED
    DATA_NODE --> USED
    MODEL_NODE --> PRODUCED
    
    GENERATED --> LINEAGE
    USED --> IMPACT
    PRODUCED --> PATTERNS
    IMPROVED --> REPRODUCE
    
    LINEAGE --> CONTEXT
    IMPACT --> IMPORTS
    PATTERNS --> ARTIFACTS
    REPRODUCE --> METADATA
    
    CONTEXT --> EXEC
    IMPORTS --> CODE
    ARTIFACTS --> RESULTS
    METADATA --> PROMPT
    
    %% Styling
    classDef tracking fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef database fill:#f1f8e9,stroke:#689f38,stroke-width:2px
    classDef nodes fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef relationships fill:#fce4ec,stroke:#e91e63,stroke-width:2px
    classDef queries fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px
    classDef state fill:#e8f5e8,stroke:#4caf50,stroke-width:2px
    
    class PROMPT,CODE,EXEC,RESULTS tracking
    class NEO4J database
    class EXP_NODE,AGENT_NODE,DATA_NODE,MODEL_NODE nodes
    class GENERATED,USED,PRODUCED,IMPROVED relationships
    class LINEAGE,IMPACT,PATTERNS,REPRODUCE queries
    class CONTEXT,IMPORTS,ARTIFACTS,METADATA state
```

## 6. Deployment Architecture

```mermaid
%%{init: {"flowchart": {"htmlLabels": true, "curve": "cardinal", "useMaxWidth": true}, "layout": "elk"}}%%
graph LR
    subgraph "Development Environment"
        VSCODE["VS Code<br/>Development IDE"]
        PLUTO["Pluto.jl<br/>Interactive Notebooks"]
        REPL["Julia REPL<br/>Testing Environment"]
        GIT["Git Repository<br/>Version Control"]
    end
    
    subgraph "Agent Services"
        ORCHESTRATOR["Ray Serve<br/>Agent Orchestration"]
        
        subgraph "Agent Containers"
            META["Meta-Controller<br/>Kubernetes Pod"]
            PLAN["Planning Agent<br/>Kubernetes Pod"]
            CODE["Code-Gen Agent<br/>Kubernetes Pod"]
            EVAL["Evaluation Agent<br/>Kubernetes Pod"]
        end
        
        subgraph "Execution Environment"
            JULIA_WORKER["Julia Workers<br/>ML Processing"]
            PLUTO_SERVER["Pluto Server<br/>Notebook Hosting"]
            ARTIFACT_STORE["Artifact Storage<br/>S3 Compatible"]
        end
    end
    
    subgraph "Data Infrastructure"
        GRAPH_DB["Neo4j Cluster<br/>Knowledge Graph"]
        MESSAGE_BUS["Redis/RabbitMQ<br/>Agent Communication"]
        MONITORING["Prometheus<br/>Metrics & Alerts"]
        LOGGING["ELK Stack<br/>Centralized Logging"]
    end
    
    subgraph "External Integrations"
        LLM_API["LLM APIs<br/>OpenAI, Anthropic"]
        DATA_SOURCES["Data Sources<br/>APIs, Databases"]
        NOTIFICATION["Notifications<br/>Slack, Email"]
        BACKUP["Backup Storage<br/>Long-term Archive"]
    end
    
    subgraph "Resource Management"
        SCALING["Auto-scaling<br/>CPU & Memory Based"]
        COST["Cost Optimization<br/>Spot Instances"]
        SECURITY["Security<br/>RBAC & Encryption"]
        NETWORKING["Load Balancing<br/>Service Mesh"]
    end
    
    %% Development to Production Flow
    VSCODE --> GIT
    PLUTO --> GIT
    REPL --> GIT
    GIT --> ORCHESTRATOR
    
    %% Agent Orchestration
    ORCHESTRATOR --> META
    ORCHESTRATOR --> PLAN
    ORCHESTRATOR --> CODE
    ORCHESTRATOR --> EVAL
    
    %% Agent Communication
    META --> MESSAGE_BUS
    PLAN --> MESSAGE_BUS
    CODE --> MESSAGE_BUS
    EVAL --> MESSAGE_BUS
    
    %% Execution Flow
    META --> JULIA_WORKER
    CODE --> JULIA_WORKER
    PLUTO --> PLUTO_SERVER
    JULIA_WORKER --> ARTIFACT_STORE
    
    %% Data Infrastructure Connections
    ORCHESTRATOR --> GRAPH_DB
    JULIA_WORKER --> GRAPH_DB
    MESSAGE_BUS --> MONITORING
    ARTIFACT_STORE --> LOGGING
    
    %% External Integrations
    PLAN --> LLM_API
    CODE --> LLM_API
    JULIA_WORKER --> DATA_SOURCES
    MONITORING --> NOTIFICATION
    ARTIFACT_STORE --> BACKUP
    
    %% Resource Management
    ORCHESTRATOR --> SCALING
    JULIA_WORKER --> COST
    MESSAGE_BUS --> SECURITY
    GRAPH_DB --> NETWORKING
    
    %% Styling
    classDef development fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef agents fill:#f1f8e9,stroke:#689f38,stroke-width:2px
    classDef containers fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef execution fill:#fce4ec,stroke:#e91e63,stroke-width:2px
    classDef infrastructure fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px
    classDef external fill:#e8f5e8,stroke:#4caf50,stroke-width:2px
    classDef management fill:#fff8e1,stroke:#fbc02d,stroke-width:2px
    
    class VSCODE,PLUTO,REPL,GIT development
    class ORCHESTRATOR agents
    class META,PLAN,CODE,EVAL containers
    class JULIA_WORKER,PLUTO_SERVER,ARTIFACT_STORE execution
    class GRAPH_DB,MESSAGE_BUS,MONITORING,LOGGING infrastructure
    class LLM_API,DATA_SOURCES,NOTIFICATION,BACKUP external
    class SCALING,COST,SECURITY,NETWORKING management
```

## Usage Instructions

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
```
