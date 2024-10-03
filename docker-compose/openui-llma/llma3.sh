# Run LLMA3
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

# Run OpenApi Web
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main