The problem
When you are trying to remove a Docker Image, you get an error as shown below.

# docker rmi d123f4e55e12
Error response from daemon: conflict: unable to delete d123f4e55e12 (cannot be forced) - image is being used by running container 0f1262bd1285
For this error to occur, there must be a container on the system that is dependent on the image. The error reports which container is using the image, remove the container before removing the image.

Solution
1. You have several Docker images pulled from the docker hub on to your Docker node. And you want to delete the centos image from the docker node.


# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
fedora              latest              422dc563ca32        3 days ago          252MB
ubuntu              latest              dd6f76d9cc90        13 days ago         122MB
hello-world         latest              725dcfab7d63        2 weeks ago         1.84kB
centos              latest              d123f4e55e12        2 weeks ago         197MB
2. To find which container is using the centos Image, use the below command.

# docker ps -a 
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                    PORTS               NAMES
0f1262bd1285        centos              "/bin/bash"         5 minutes ago       Up 5 minutes                                  dreamy_gates
As you can see in the output above, the Docker container “dreamy_gates” is using our centos image.

3. First we need to stop the container “dreamy_gates”. To do so use the command below:

# docker stop 0f1262bd1285
0f1262bd1285
4. Now you can delete the Docker container.

# docker rm 0f1262bd1285
0f1262bd1285
5. And finally, you can delete the docker image for centos.

# docker rmi d123f4e55e12
Untagged: centos:latest
Untagged: centos@sha256:4565fe2dd7f4770e825d4bd9c761a81b26e49cc9e3c9631c58cfc3188be9505a
Deleted: sha256:d123f4e55e1200156d9cbcf4421ff6d818576e4f1e29320a408c72f022cfd0b1
Deleted: sha256:cf516324493c00941ac20020801553e87ed24c564fb3f269409ad138945948d4
6. Verify that the image is deleted using the command “docker images”.

# docker images
