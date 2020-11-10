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
