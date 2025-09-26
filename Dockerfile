# Small, fast base
FROM python:3.11-slim

# Avoid interactive prompts during installs
ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# System deps (build tools + common libs)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Workdir inside container
WORKDIR /app

# Copy only dependency file first for better caching
COPY requirements.txt /app/requirements.txt

# Install Python deps
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Create a working folder that we'll mount onto
RUN mkdir -p /work

# Expose Jupyter's port
EXPOSE 8888

# Default command: launch Jupyter Lab bound to all interfaces
# (We’ll see the token in logs; you can set a password later if you want.)
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.allow_origin='*'", "--NotebookApp.disable_check_xsrf=True", "--NotebookApp.token="]
