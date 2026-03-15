# Recommended Additions for AI Development

Tools and enhancements specifically for AI/ML development workflows.

---

## 🎯 Priority Categories

### P0 - Critical for AI Work
Essential tools you'll use daily for AI development.

### P1 - Highly Recommended
Very useful, should install soon.

### P2 - Nice to Have
Helpful but not urgent.

---

## P0 - CRITICAL FOR AI DEVELOPMENT

### 1. Jupyter Notebooks
**Essential for AI experimentation and prototyping**

```bash
# Install
pipx install jupyterlab
pipx install notebook

# Usage
jupyter lab                    # Modern interface
jupyter notebook              # Classic interface

# Extensions to add
pip install jupyter-ai        # AI assistant in Jupyter
pip install nbconvert         # Convert notebooks
```

**Why:** Prototyping AI workflows, testing Claude API, data exploration.

### 2. Ollama - Local LLM Testing
**Run LLMs locally before deploying to Bedrock**

```bash
# Install
brew install ollama

# Download models
ollama pull llama2
ollama pull mistral
ollama pull codellama

# Run
ollama run llama2

# Use in Python
pip install ollama-python
```

**Why:** Test prompts locally, save costs, work offline.

### 2.5. LM Studio - GUI for Local LLMs
**Visual interface for running LLMs (Alternative/Complement to Ollama)**

```bash
# Install
brew install --cask lm-studio

# Usage
# 1. Open from Applications
# 2. Browse and download models in GUI
# 3. Chat with models directly
# 4. Start local API server (localhost:1234)
# 5. OpenAI-compatible API

# Use in Python (same as OpenAI)
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:1234/v1",
    api_key="not-needed"
)

response = client.chat.completions.create(
    model="local-model",
    messages=[{"role": "user", "content": "Hello!"}]
)
```

**Why:** Quick visual testing, demos, easier for non-technical experimentation.

**Ollama vs LM Studio:**
- **Use Ollama**: Scripting, automation, CI/CD, Jupyter notebooks
- **Use LM Studio**: Quick testing, demos, visual model comparison
- **Recommended**: Install both! They complement each other perfectly.

### 3. Vector Database - pgvector
**PostgreSQL extension for vector similarity search**

```bash
# Install extension
brew install pgvector

# In PostgreSQL
CREATE EXTENSION vector;

# Create embeddings table
CREATE TABLE documents (
  id SERIAL PRIMARY KEY,
  content TEXT,
  embedding vector(1536)  -- for OpenAI/Claude embeddings
);

# Search by similarity
SELECT * FROM documents
ORDER BY embedding <-> '[...]'::vector
LIMIT 10;
```

**Why:** Core for RAG implementations, semantic search.

### 4. ChromaDB
**Easy vector database for prototyping**

```bash
# Install (per project)
pip install chromadb

# Usage
import chromadb
client = chromadb.Client()
collection = client.create_collection("docs")
```

**Why:** Quick RAG prototypes, easier than pgvector for testing.

### 5. httpie - Better HTTP Client
**Test AI APIs quickly**

```bash
# Install
brew install httpie

# Usage
http POST https://api.anthropic.com/v1/messages \
  x-api-key:$ANTHROPIC_API_KEY \
  model=claude-3-sonnet-20240229 \
  messages:='[{"role":"user","content":"Hello"}]'

# Better than curl for JSON
http GET https://api.example.com/embeddings \
  Authorization:"Bearer $TOKEN"
```

**Why:** Testing Claude API, debugging AI endpoints.

---

## P1 - HIGHLY RECOMMENDED

### 6. API Testing - Insomnia/Postman
**GUI for API testing and debugging**

```bash
# Choose one:
brew install --cask insomnia       # Free, simpler
brew install --cask postman        # More features

# Alternative: httpie-desktop
brew install --cask httpie
```

**Why:** Test complex AI API workflows, save requests, team collaboration.

### 7. Advanced System Monitoring
**Monitor AI workload performance**

```bash
# Glances - comprehensive monitoring
brew install glances

# Bottom - Rust-based, beautiful
brew install bottom

# Usage
glances                    # Press 'h' for help
btm                       # bottom command
```

**Why:** Monitor GPU usage, memory for AI workloads, Python processes.

### 8. Database GUI - DBeaver
**Inspect vector databases, embeddings**

```bash
# Universal database tool
brew install --cask dbeaver-community

# Alternative for PostgreSQL only
brew install --cask tableplus
```

**Why:** Visualize embeddings, debug vector queries, inspect training data.

### 9. Kubernetes Tools (if using k8s)
**Deploy AI models to Kubernetes**

```bash
# k9s - Terminal UI for k8s
brew install k9s

# kubectx/kubens - Switch contexts/namespaces
brew install kubectx

# stern - Multi-pod log tailing
brew install stern

# Helm - Package manager
brew install helm

# Usage
k9s                        # Launch k9s
kubectx production        # Switch context
stern api-*               # Tail logs from api pods
```

**Why:** If deploying AI services to k8s clusters.

### 10. Documentation Tools
**Document AI architectures and workflows**

```bash
# Mermaid - Diagrams from text
brew install mermaid-cli

# Graphviz - Graph visualization
brew install graphviz

# Usage
mmdc -i diagram.mmd -o diagram.png

# Create architecture diagrams
graph TD
    A[User] --> B[API Gateway]
    B --> C[Claude/Bedrock]
    B --> D[Vector DB]
    C --> E[Response]
    D --> C
```

**Why:** Document RAG pipelines, AI architectures, data flows.

---

## P2 - NICE TO HAVE

### 11. Infrastructure as Code Extensions

```bash
# Terraform version manager
brew install tfenv

# Terraform linting
brew install tflint

# Terraform docs generator
brew install terraform-docs

# Pulumi (alternative to Terraform)
brew install pulumi

# Usage
tfenv install 1.7.0
tfenv use 1.7.0
tflint
```

**Why:** Manage AI infrastructure as code.

### 12. Network & API Tools

```bash
# grpcurl - Test gRPC APIs
brew install grpcurl

# hey - HTTP load testing
brew install hey

# wrk - Modern HTTP benchmarking
brew install wrk

# Usage
grpcurl -plaintext localhost:50051 list
hey -n 1000 -c 10 https://api.example.com
```

**Why:** Load test AI APIs, benchmark response times.

### 13. Security & Secrets Management

```bash
# SOPS - Encrypt secrets in git
brew install sops

# Age - Modern encryption
brew install age

# 1Password CLI
brew install --cask 1password-cli

# Usage
sops -e secrets.yaml > secrets.enc.yaml
age-keygen -o key.txt
op item get "AWS Bedrock Key"
```

**Why:** Secure AI API keys, manage secrets.

### 14. Python Development Tools

```bash
# Hypothesis - Property-based testing
pipx install hypothesis

# mypy - Static type checking
pipx install mypy

# pytest - Testing framework
pipx install pytest

# mkdocs - Documentation
pipx install mkdocs

# Usage
mypy your_ai_code.py
pytest tests/
mkdocs serve
```

**Why:** Better AI code quality, testing, documentation.

### 15. Data Tools

```bash
# csvkit - CSV manipulation
pipx install csvkit

# jq/yq already installed - JSON/YAML processing

# xsv - Rust CSV tool (faster)
brew install xsv

# miller - CSV/JSON/TSV processing
brew install miller

# Usage
csvstat data.csv
xsv select col1,col2 data.csv
mlr --csv sort -f name data.csv
```

**Why:** Process training data, analyze AI outputs.

### 16. Git LFS
**Large file storage for AI models**

```bash
# Install
brew install git-lfs

# Setup
git lfs install

# Track large files
git lfs track "*.pkl"
git lfs track "*.model"
git lfs track "*.h5"

# Usage
git add model.pkl
git commit -m "Add trained model"
```

**Why:** Version control AI models, datasets.

### 17. Cloud Tools (Multi-cloud)

```bash
# If using multiple clouds
brew install azure-cli           # Azure
brew install google-cloud-sdk    # GCP

# Digital Ocean
brew install doctl

# Usage
az login
gcloud auth login
doctl auth init
```

**Why:** Multi-cloud AI deployments.

### 18. Alternative Shells/Tools

```bash
# Zellij - Modern tmux alternative
brew install zellij

# Nushell - Structured data shell
brew install nushell

# Usage
zellij                   # Try it out
nu                       # Nushell
```

**Why:** Experiment with alternative tools.

---

## 🎯 Recommended Installation Order

### Week 1 - Essentials
```bash
pipx install jupyterlab notebook
brew install ollama
brew install pgvector
brew install httpie
```

### Week 2 - Development
```bash
brew install --cask insomnia
brew install glances
brew install --cask dbeaver-community
```

### Week 3 - Infrastructure
```bash
brew install k9s kubectx stern
brew install tfenv tflint
brew install mermaid-cli graphviz
```

### As Needed
```bash
# Install based on your specific projects
pip install chromadb           # When doing RAG
brew install git-lfs           # When versioning models
pipx install mkdocs           # When documenting
```

---

## 📦 Project-Specific Python Libraries

**Don't install globally - use per-project venvs:**

```bash
# AI/ML Core
anthropic                  # Claude API
boto3                     # AWS SDK (for Bedrock)
langchain                 # LLM framework
langchain-anthropic       # Claude integration
openai                    # OpenAI API (if needed)

# Vector & Embeddings
chromadb                  # Vector database
sentence-transformers     # Embeddings
faiss-cpu                # Facebook AI similarity search

# Data Processing
pandas                    # Data manipulation
numpy                     # Numerical computing
polars                    # Fast dataframes (Rust-based)

# Web Frameworks
fastapi                   # API development
uvicorn                   # ASGI server
pydantic                  # Data validation

# Testing & Quality
pytest                    # Testing
pytest-asyncio           # Async testing
httpx                     # HTTP client for testing
```

---

## 🔧 VS Code Extensions for AI Development

```
# Essential
- AWS Toolkit
- Python
- Pylance
- Jupyter

# AI-Specific
- GitHub Copilot (if available)
- Tabnine
- Continue (local AI assistant)

# Data Science
- Data Wrangler
- Rainbow CSV

# API Development
- Thunder Client
- REST Client

# Documentation
- Markdown All in One
- Mermaid Markdown
```

---

## 🚀 Quick Install Script

Want to install all P0 + P1 tools? Create this:

```bash
#!/bin/bash
# install-ai-tools.sh

echo "Installing AI Development Tools..."

# P0 - Critical
pipx install jupyterlab notebook
brew install ollama
brew install pgvector
brew install httpie

# P1 - Highly Recommended
brew install --cask insomnia
brew install glances bottom
brew install --cask dbeaver-community
brew install mermaid-cli graphviz

# Optional: Kubernetes (uncomment if needed)
# brew install k9s kubectx stern helm

# Optional: IaC (uncomment if needed)
# brew install tfenv tflint terraform-docs

echo "Done! Now install per-project Python packages:"
echo "  pip install anthropic boto3 langchain chromadb"
```

---

## 💡 Usage Patterns

### AI Workflow Development
```bash
# 1. Start Jupyter for prototyping
jupyter lab

# 2. Test locally with Ollama
ollama run llama2

# 3. Test API endpoints
http POST localhost:8000/api/chat content="hello"

# 4. Monitor performance
glances

# 5. Check database
dbeaver-ce  # Open GUI
```

### Deploying to Production
```bash
# 1. Infrastructure
terraform plan
terraform apply

# 2. Deploy to k8s
kubectl apply -f deployment.yaml
k9s  # Monitor

# 3. Check logs
stern ai-service-*

# 4. Load test
hey -n 1000 https://api.example.com
```

---

## 📚 Further Reading

- [Ollama Models](https://ollama.ai/library)
- [pgvector Guide](https://github.com/pgvector/pgvector)
- [ChromaDB Docs](https://docs.trychroma.com/)
- [LangChain Docs](https://python.langchain.com/)
- [FastAPI](https://fastapi.tiangolo.com/)

---

**Install what you need, when you need it. Start with P0, add P1 as you go!**
