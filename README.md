# Data Science Docker Environment

A reproducible Python data science environment using Docker + Jupyter.

## Tailorings
- Review the requirements.txt in relation to the intended project
- Likewise, make sure the Dockerfile has the proper Python version and such

## Commands
### Build Phase
```docker build -t ds-env:latest .```

### Run Phase
```
docker run --rm -it \
  -p 8888:8888 \
  -v "$(pwd)/work:/work" \
  ds-env:latest
```
