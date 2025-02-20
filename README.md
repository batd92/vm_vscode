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
1. Build docker images: ```docker build -t htplus-vscode:latest .```
2. Set tag image: ```docker tag htplus-vscode:latest <yourusername>/htplus-vscode:latest```
3. Push image to DockerHub: ```docker push yourusername/htplus-vscode:latest``` 

##  Docker Compose (Docker Swarm)

1. Create docker swarm: ```docker swarm leave --force```
2. Init docker swarm: ```docker swarm init```
3. Run (openn git bash): ```./docker_deployment.sh```
4. Check stack: ```docker stack ls```

## Kubernetes

### Run with Localhost:

1. Build image ```docker build -t my-vscode-image -f vscode/Dockerfile .```
2. Load image into Kubernetes ```docker tag my-vscode-image my-vscode-image:latest```
3. Run: ```kubectl apply -f k8s/```
4. Check status:```kubectl get pods,svc,ingress```

## Tạo SSL (local)

```openssl req -x509 -newkey rsa:4096 -keyout tls.key -out tls.crt -days 365 -nodes -subj "/CN=vscode.localhost"```
