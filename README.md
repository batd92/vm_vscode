Run VS Code on any machine anywhere and access it in the browser.
## Project struct
```
root/
│── docker-compose.yml
│── traefik/
│   ├── traefik.yml
│   ├── dynamic_conf.yml
│── vscode/
│   ├── Dockerfile
│   ├── bin/
│   │   ├── entrypoint.sh
│── vscode-image/
│   ├── Dockerfile
│   ├── bin/
│   │   ├── entrypoint.sh
│── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── pvc.yaml
│   ├── config.yaml
│   ├── ingress.yaml
│── .env
```
## DockerHub
build docker images: ```docker build -t htplus-vscode:latest .```
set tag image: ```docker tag htplus-vscode:latest <yourusername>/htplus-vscode:latest```
push image to DockerHub: ```docker push yourusername/htplus-vscode:latest``` 

##  Docker Compose (Docker Swarm)
create docker swarm: ```docker swarm leave --force```
init docker swarm: ```docker swarm init```

Run: ```docker stack deploy -c docker-compose.yml vscode_stack```
Check stack: ```docker stack ls```

## Kubernetes

### Run with Localhost:

1. Build image ```docker build -t my-vscode-image -f vscode/Dockerfile .```
2. Load image into Kubernetes ```docker tag my-vscode-image my-vscode-image:latest```
3. Run: ```kubectl apply -f k8s/```
4. Check status:```kubectl get pods,svc,ingress```

## Tạo SSL (local)

```openssl req -x509 -newkey rsa:4096 -keyout tls.key -out tls.crt -days 365 -nodes -subj "/CN=vscode.localhost"```
