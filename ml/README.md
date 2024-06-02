
```sh
# build
docker build -t myimage .

# run detach mode
docker run -d --name mycontainer -p 80:80 myimage
```
