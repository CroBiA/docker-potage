[POTAGE](https://github.com/CroBiAd/potage) is a web-based tool for visualising gene expression data in the context
of the IWGSC CSS contigs.

For further information please follow any of these links:

 * `POTAGE` [Docker Hub](https://hub.docker.com/r/crobiad/potage/) for information on using the official Docker image.
 * `POTAGE` [GitHub code repository](https://github.com/CroBiAd/potage) for web application source code.

# Developer Information

We make use of Docker Hub's [automated builds](https://docs.docker.com/docker-hub/builds/). This means that whenever the code
in this GitHub repository, Docker Hub will initialise an automated build to create a POTAGE image. This image, will then be
available from Docker Hub for others to use within a mater of minutes.

The general workflow for getting a new POTAGE image available on Docker Hub for everyone to use, is as follows:

First, clone the `docker-potage` repository from GitHub:

```bash
git clone --recursive https://github.com/CroBiAd/docker-potage
cd docker-potage
```

If required, update the submodule(s) to their latest commit(s):

```bash
git submodule update --recursive --remote
git add .
git commit -m "Updated submodules to latest revision"
```

Make any changes you see fit to the `docker-potage` repository, commit and push your changes to GitHub:

```bash
# Make some changes ...
# Then:
git add .
git commit -m "I made some changes"
git push
```

At this point, Docker Hub will initiate an automated build. You can see it's progress at https://hub.docker.com/r/crobiad/potage/builds/.

# Testing Locally

If you want to test changes locally before pushing to the `docker-potage` repository and initiating an automated build, you
can build and deploy a Docker image locally:

Build and tag a `potage` image:

```bash
docker build --tag crobiad/potage ./
```

Now run a container locally using this image, ensuring any previous containers called `POTAGE` are stopped:

```bash
docker stop POTAGE && \
docker rm POTAGE && \
docker run --detach \
  --name POTAGE  \
  --publish 80:8080 \
  --volume "potage_blastdb:/var/tomcat/persist/potage_data/global/blast_db" \
  crobiad/potage
```
