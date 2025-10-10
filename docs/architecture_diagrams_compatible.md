# DSAssist Architecture Diagrams (Compatible Version)

This document contains Mermaid diagrams with enhanced compatibility for older versions of Mermaid (8.8.0+).

## 1. High-Level System Architecture (Flowchart)

```mermaid
flowchart TB
    UI[User Interface] --> MC[Meta-Controller]
    CLI[Command Line] --> MC
    PLUTO[Pluto Notebooks] --> MC
    
    MC --> PA[Planning Agent]
    MC --> CGA[Code Generation Agent]
    MC --> EA[Evaluation Agent]
    MC --> RA[Reflection Agent]
    
    PA --> SB[Sandbox Execution]
    CGA --> SB
    SB --> JML[Julia Native ML]
    SB --> PLOT[Interactive Plotting]
    
    SB --> EA
    EA --> KG[Knowledge Graph]
    RA --> KG
    
    PA --> LLM[LLM Client]
    CGA --> LLM
    EA --> LLM
    LLM --> OPENAI[OpenAI API]
    
    KG --> NEO4J[Neo4j Database]
    
    style MC fill:#f9f,stroke:#333,stroke-width:4px
    style JML fill:#9f9,stroke:#333,stroke-width:2px
    style KG fill:#99f,stroke:#333,stroke-width:2px
```

## 2. Julia ML Pipeline (Block Diagram)

```mermaid
block-beta
    columns 3
    
    CSV["CSV Files"]:1
    JSON["JSON Data"]:1
    API["External APIs"]:1
    
    LOAD["Data Loading"]:3
    VALID["Data Validation"]:3
    
    ENCODE["Categorical Encoding"]:1
    STANDARD["Feature Scaling"]:1
    OUTLIER["Outlier Detection"]:1
    
    SPLIT["Train/Test Split"]:1
    CV["Cross Validation"]:1
    TRAIN["Model Training"]:1
    
    BOOTSTRAP["Bootstrap CI"]:1
    FEATURE["Feature Importance"]:1
    ENSEMBLE["Ensemble Methods"]:1
    
    METRICS["Model Metrics"]:1
    PLOTS["Visualizations"]:1
    REPORTS["Reports"]:1
    
    CSV --> LOAD
    JSON --> LOAD
    API --> LOAD
    
    LOAD --> VALID
    VALID --> ENCODE
    VALID --> STANDARD
    VALID --> OUTLIER
    
    ENCODE --> SPLIT
    STANDARD --> CV
    OUTLIER --> TRAIN
    
    SPLIT --> BOOTSTRAP
    CV --> FEATURE
    TRAIN --> ENSEMBLE
    
    BOOTSTRAP --> METRICS
    FEATURE --> PLOTS
    ENSEMBLE --> REPORTS
```

## 3. Agent Communication Flow (Sequence)

```mermaid
sequenceDiagram
    participant User
    participant MC as Meta Controller
    participant PA as Planning Agent
    participant CGA as Code Gen Agent
    participant SB as Sandbox
    participant EA as Evaluation Agent
    participant KG as Knowledge Graph
    
    User->>MC: Research Question
    MC->>PA: Plan Request
    PA->>KG: Query Patterns
    KG-->>PA: Historical Data
    PA-->>MC: Generated Plan
    
    MC->>CGA: Code Request
    CGA->>KG: Query Templates
    KG-->>CGA: Code Patterns
    CGA-->>MC: Generated Code
    
    MC->>SB: Execute Code
    SB-->>MC: Results
    
    MC->>EA: Evaluate Results
    EA-->>MC: Evaluation
    
    MC->>KG: Update Knowledge
    MC->>User: Final Results
```

## 4. Interactive Plotting Architecture

```mermaid
graph LR
    DATA[Data Input] --> PLUTO[Pluto Notebook]
    
    PLUTO --> CONTROLS[Interactive Controls]
    CONTROLS --> SLIDERS[Sliders]
    CONTROLS --> DROPDOWNS[Dropdowns]
    CONTROLS --> BUTTONS[Buttons]
    
    SLIDERS --> CALC[Calculations]
    DROPDOWNS --> CALC
    BUTTONS --> CALC
    
    CALC --> PLOTS[Plot Generation]
    PLOTS --> PLOTLY[PlotlyJS Backend]
    PLOTS --> GR[GR Backend]
    
    PLOTLY --> OUTPUT[Interactive Output]
    GR --> OUTPUT
    
    OUTPUT --> EXPORT[Export Options]
    EXPORT --> HTML[HTML]
    EXPORT --> PNG[PNG]
    EXPORT --> PDF[PDF]
    
    style PLUTO fill:#e1f5fe
    style PLOTS fill:#f3e5f5
    style OUTPUT fill:#e8f5e8
```

## 5. Knowledge Graph Structure

```mermaid
flowchart TB
    subgraph "Sources"
        UQ[User Queries]
        HE[Historical Experiments]
        CP[Code Patterns]
        PR[Previous Results]
    end
    
    subgraph "Knowledge Graph"
        NG[Neo4j Graph Database]
        
        subgraph "Nodes"
            EN[Experiment Nodes]
            CN[Code Nodes]
            RN[Result Nodes]
            PN[Pattern Nodes]
            AN[Agent Nodes]
        end
    end
    
    subgraph "Provenance"
        EL[Experiment Lineage]
        PM[Performance Metrics]
        AD[Agent Decisions]
        CV[Code Versions]
    end
    
    subgraph "Queries"
        SS[Similarity Search]
        IA[Improvement Analysis]
        DS[Debug Support]
        OH[Optimization Hints]
    end
    
    subgraph "Learning"
        PL[Pattern Learning]
        AT[Agent Tuning]
        AI[Auto Improvement]
    end
    
    UQ --> EN
    HE --> EN
    CP --> PN
    PR --> RN
    
    EN --> NG
    CN --> NG
    RN --> NG
    PN --> NG
    AN --> NG
    
    AN --> CN
    CN --> RN
    EN --> PN
    
    CN --> EL
    RN --> PM
    AN --> AD
    CN --> CV
    
    NG --> SS
    NG --> IA
    NG --> DS
    NG --> OH
    
    PM --> PL
    AD --> AT
    PL --> AI
    AI --> PN
    
    style NG fill:#e1f5fe
    style PL fill:#f3e5f5
    style AI fill:#e8f5e8
```

## 6. Deployment Architecture

```mermaid
flowchart TB
    CLIENT[Client Applications] --> GATEWAY[API Gateway]
    
    GATEWAY --> AUTH[Authentication]
    GATEWAY --> RATE[Rate Limiting]
    
    AUTH --> SERVICES[Microservices]
    RATE --> SERVICES
    
    SERVICES --> PLANNING[Planning Service]
    SERVICES --> CODEGEN[CodeGen Service]
    SERVICES --> EVAL[Evaluation Service]
    
    PLANNING --> QUEUE[Message Queue]
    CODEGEN --> QUEUE
    EVAL --> QUEUE
    
    QUEUE --> STORAGE[Data Storage]
    STORAGE --> NEO4J[Neo4j]
    STORAGE --> POSTGRES[PostgreSQL]
    STORAGE --> REDIS[Redis Cache]
    
    SERVICES --> MONITOR[Monitoring]
    MONITOR --> PROMETHEUS[Prometheus]
    MONITOR --> GRAFANA[Grafana]
    
    style GATEWAY fill:#e1f5fe
    style SERVICES fill:#f3e5f5
    style STORAGE fill:#e8f5e8
    style MONITOR fill:#fff3e0
```

## Usage Notes

### Compatibility
- These diagrams are compatible with Mermaid 8.8.0+
- Removed special characters that might cause parsing issues
- Simplified syntax for better rendering across platforms

### Alternative Formats
If you still encounter issues, try:
1. Using the block diagram format (shown in example 2)
2. Converting to flowchart format (shown in examples 1, 4, 6)
3. Using sequence diagrams for process flows (example 3)

### Troubleshooting
- Remove any special characters (², &, etc.)
- Use double quotes for all node labels
- Avoid HTML line breaks in older versions
- Simplify complex subgraph structures