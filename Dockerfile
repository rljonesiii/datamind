FROM julia:1.9

# Install Python for hybrid execution
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY Project.toml .
COPY requirements.txt .

# Install Julia dependencies
RUN julia --project=. -e "using Pkg; Pkg.instantiate()"

# Install Python dependencies
RUN pip3 install -r requirements.txt

# Copy source code
COPY src/ src/
COPY config/ config/
COPY examples/ examples/

# Create experiments directory
RUN mkdir -p experiments

# Set environment variables
ENV JULIA_NUM_THREADS=4
ENV PYTHON_PATH=/usr/bin/python3

# Expose port for any web interfaces
EXPOSE 8000

# Run the main application
CMD ["julia", "--project=.", "src/main.jl"]