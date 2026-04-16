FROM python:3.11-slim

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gosu nodejs npm ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install claude-code CLI via npm
RUN npm install -g @anthropic-ai/claude-code 2>/dev/null || true

# Create agent user
RUN useradd -u 1000 -m -s /bin/bash agent
WORKDIR /app

# Install Python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy adapter code
COPY adapter.py .
COPY __init__.py .

# Set the adapter module for runtime discovery
ENV ADAPTER_MODULE=adapter

ENTRYPOINT ["molecule-runtime"]
