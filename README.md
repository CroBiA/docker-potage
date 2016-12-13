[POTAGE](https://github.com/CroBiA/potage) is a web-based tool for visualising gene expression data in the context
of the IWGSC CSS contigs.

For further information please follow any of these links:

 * `POTAGE` [Docker Hub](https://hub.docker.com/r/crobia/potage/) for information on using the official Docker image.
 * `POTAGE` [GitHub code repository](https://github.com/CroBiA/potage) for web application source code.

# Developer Information

## Building a POTAGE Docker Image
 
First, clone the `Dockerfiles` code repository.

```bash
git clone --recursive https://github.com/CroBiA/Dockerfiles
cd Dockerfiles
```

Update the submodule to its latest commit:

```bash
git submodule update --init ./potage
```

Build and tag a `potage` image:

```bash
docker build --tag crobia/potage ./potage
```

# Publish the container to Docker Hub
 
```bash
docker login
docker push crobia/potage
``
