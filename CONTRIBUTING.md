[POTAGE](https://github.com/CroBiA/potage) is a web-based tool for visualising gene expression data in the context
of the IWGSC CSS contigs.

For further information please follow any of these links:

 * `POTAGE` [Docker Hub](https://hub.docker.com/r/crobia/potage/) for information on using the official Docker image.
 * `POTAGE` [GitHub code repository](https://github.com/CroBiA/potage) for web application source code.

# Developer Information

## Building a POTAGE Docker Image

First, clone the repository.

```bash
git clone --recursive https://github.com/CroBiA/docker-potage
cd docker-potage
```

Update the submodule to its latest commit:

```bash
git submodule update --recursive --remote
git submodule update --init
```

Build and tag a `potage` image:

```bash
docker build --tag crobia/potage ./
```

# Publish the Image to Docker Hub

```bash
docker login
docker push crobia/potage
```
