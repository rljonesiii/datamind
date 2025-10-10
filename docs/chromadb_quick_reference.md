# ChromaDB-Julia Quick Reference Guide

## 🚀 Quick Start

### **Installation**
```bash
# Install ChromaDB
pip install chromadb

# Test integration
julia --project=. -e "include(\"src/DSAssist.jl\"); using .DSAssist; println(\"✓ Ready\")"
```

### **Basic Usage**
```julia
# Create enhanced knowledge graph
ekg = initialize_vector_knowledge_graph(KnowledgeGraph())

# Embed research question
embed_research_question(ekg, "What is customer churn?", "exp_001")

# Semantic search
results = semantic_similarity_search(ekg, "customer behavior analysis")
```

## 🔧 Key Functions

### **Embedding Generation**
```julia
# OpenAI embeddings (requires API key)
embedding = get_text_embedding("text", model="openai")

# Simple embeddings (pure Julia)
embedding = get_text_embedding("text", model="simple")
```

### **Vector Storage**
```julia
# Store in ChromaDB
embed_research_question(ekg, question, experiment_id)

# Batch storage
batch_embed_experiments(ekg, experiments)
```

### **Semantic Search**
```julia
# Find similar experiments
insights = enhanced_query_insights(ekg, research_question, k=5)

# Cross-collection search
results = cross_collection_search(ekg, query, k=10)
```

## 🛡️ Fallback Hierarchy

| Priority | Storage | Embedding | Requirements |
|----------|---------|-----------|--------------|
| 1 | ChromaDB | OpenAI | `pip install chromadb` + API key |
| 2 | ChromaDB | Simple | `pip install chromadb` only |
| 3 | In-Memory | Simple | Pure Julia (always works) |

## ⚠️ Troubleshooting

### **ChromaDB Not Available**
```bash
# Install ChromaDB
pip install chromadb

# Restart Julia REPL
```

### **PyCall Issues**
```julia
# Rebuild PyCall
using Pkg
ENV["PYTHON"] = ""  # Use default Python
Pkg.build("PyCall")
```

### **Debug Mode**
```julia
ENV["DSASSIST_DEBUG"] = "true"
# Run test_vector_database() function
```

## 🔍 Configuration

### **Environment Variables**
```bash
export OPENAI_API_KEY=your_key_here
export DSASSIST_EMBEDDING_MODEL=openai  # or "simple"
export DSASSIST_SIMILARITY_THRESHOLD=0.5
```

### **Runtime Config**
```julia
config["vector_db"] = Dict(
    "enabled" => true,
    "embedding_model" => "openai",
    "similarity_threshold" => 0.5
)
```

## 📊 Performance Tips

### **For Development**
- Use `model="simple"` for fast local testing
- In-memory fallback requires no external dependencies

### **For Production**
- Use `model="openai"` for highest quality embeddings
- ChromaDB provides persistent storage and sharing

### **Memory Management**
- Embeddings are cached in Julia for fast access
- ChromaDB provides persistent storage between sessions

## 🎯 Integration Examples

### **In Existing Scripts**
```julia
# Replace standard workflow
experiment = create_experiment(question)

# With enhanced workflow  
experiment = create_enhanced_experiment(question, context)
controller = create_enhanced_controller(experiment)
results = run_enhanced_workflow(controller)
```

### **Custom Semantic Search**
```julia
# Find related experiments
similar = get_semantic_insights(knowledge_graph, "risk analysis")

# Cross-domain discovery
weather_to_finance = semantic_similarity_search(ekg, "seasonal patterns")
```

---

**For detailed documentation, see `docs/chromadb_julia_integration.md`**