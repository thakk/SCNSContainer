# Convert docker image from local registry to singularity. Handy for development and debug
# Launch local registry
sudo docker run -d -p 5000:5000 --restart=always --name registry registry:2 # Start local registry
# Build docker 
sudo docker build -t scnscontainer:latest .  # Build Dockerfile in current directory
sudo docker tag scnscontainer:latest localhost:5000/scnscontainer # Tag to local registry
sudo docker push localhost:5000/scnscontainer:latest # Push to local registry
# Build singularity container from local registry
sudo SINGULARITY_NOHTTPS=1 singularity build scnscontainer-latest.sif docker://localhost:5000/scnscontainer:latest


