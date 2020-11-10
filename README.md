# kubernetes-exercises

### Build docker image for cv-service
```
cd cv-service
sudo docker build -t lityourcode/cv-service:0.1 .
```
### Run the docker image on local machine
```
sudo docker run -it --publish 8080:8080 lityourcode/cv-service:0.1
```

### Push the image to docker hub
```
sudo docker image push lityourcode/cv-service:0.1
```

### Create a Kubernetes secret
```
kubectl create secret generic credentials --from-env-file ../secrets.txt
```

### SSH to a pod
```
kubectl get pods -o wide
kubectl exec -it cv-service-deploy-8549876bb5-tcfgt -- bash
```

### Abuse cURL to check a remote Redis server
```
exec 3<>/dev/tcp/redis-service-name/6379 && echo -e "PING\r\n" >&3 && head -c 7 <&3
```
