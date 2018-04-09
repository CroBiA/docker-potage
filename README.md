[![](https://images.microbadger.com/badges/image/crobiad/potage.svg)](https://microbadger.com/images/crobiad/potage "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/crobiad/potage.svg)](https://microbadger.com/images/crobiad/potage "Get your own version badge on microbadger.com")

# Supported tags and respective `Dockerfile` links
  * `latest` [(potage/Dockerfile)](https://github.com/CroBiA/docker-potage/blob/master/Dockerfile)

# What is POTAGE?
POTAGE (pronounced "[pəʊˈtɑːʒ](http://img2.tfd.com/pron/mp3/en/UK/df/dfskskssdfd5drh7.mp3)") is a web-based tool for integrating genetic map location with gene expression data and inferred functional annotation in wheat.

# POTAGE Web Server

You can access the public POTAGE web server (http://crobiad.agwine.adelaide.edu.au/potage) which contains a limited number of published gene
expression data sets.

# How to deploy this image using [Singularity](http://singularity.lbl.gov) 

Build a local, writable image based on the image from docker hub

```
singularity build --sandbox potage/ docker://crobiad/potage
```

Optional: for sequence similarity search fuctionallity to be available in POTAGE, reference sequences need to be downloaded and indexed in a BLAST database 

```
singularity exec --writable --pwd /var/tomcat/persist/potage_data potage setup_db
```

<!-- Note that if this fails, it may be  due to [https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/](https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/) being off-line -->

Deploy

```
singularity run --writable --pwd /var/tomcat/persist/potage_data potage
```

The running instance of POTAGE should now be available under [http://localhost:8080/potage](http://localhost:8080/potage)


# How to deploy this image using [Docker](https://www.docker.com/)

## Quick Start

We assume you are running `docker >= v1.9.0`. If not, the `docker volume` command will not work

```bash
# Create a volume for persistent storage of the BLAST databases
$ docker volume create --name potage_blastdb
# Create a log file on the host for the persistent storage of POTAGE visitor information
$ sudo touch /var/log/potage_visits.log
# Create a running container from the POTAGE image
#   It will be accessible from http://host-ip/potage
$ docker run --detach \
  --name POTAGE  \
  --publish 80:8080 \
  --volume "potage_blastdb:/var/tomcat/persist/potage_data/global/blast_db" \
  --volume "/var/log/potage_visits.log:/var/tomcat/persist/potage_data/visits.txt" \
  crobiad/potage
# Download and setup the BLAST database
#   Getting files from URGI by default
$ docker exec POTAGE \
  setup_db
```

You should now be able to access POTAGE by visiting `http://hostname/potage`

## start a POTAGE instance

```bash
$ docker run --detach --name POTAGE crobiad/potage
```
You can test if it running by visiting `http://container-ip:8080/potage` in your browser. To find the IP address of the container run this:

```bash
$ docker inspect \
  --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' POTAGE
```

If you need access to the container from outside the host running docker, on port 8888 for example:

```bash
$ docker run --detach --name POTAGE --publish 8888:8080 crobiad/potage
```

You can then go to `http://localhost:8888/potage` or `http://host-ip:8888/potage` or `http://hostname:8888/potage`

## start with persistent storage

Data created and written by a container is not persistent. That is, once the container ceases to exist any data/files created by the container no longer exist. This presents a problem for POTAGE since it needs to download a large amount of data and setup a BLAST database. If this information was lost each time a container was stopped, you could waste a lot of time and network bandwidth re-downloading and formatting this data.

To get around this issue, we will use [docker volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Docker takes care of managing the location of the files written to the volume, all we need to do is to create the volume and then tell docker where to mount the volume in the container:

```bash
$ docker volume create --name potage_blastdb
$ docker run --detach \
  --name POTAGE \
  --volume "potage_blastdb:/var/tomcat/persist/potage_data/global/blast_db" \
  crobiad/potage
```

## setup the BLAST database

POTAGE uses a BLAST database of the International Wheat Genome Sequencing Consortium's (IWGSC) Chromosomal Survey Sequences (CSS). Once you have a POTAGE container running, preferably with persistent storage attached you can download and setup the required BLAST database:

```bash
$ docker exec POTAGE setup_db
```

By default, the data will be retrieved directly from [URGI](https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/). This can be slow for a variety of reasons, including your geographic location, load on the URGI network etc. For this reason we have created a copy of this data on the NeCTAR Research Cloud in Australia. To use this mirror, simply specify a `BASE_URL`:

```bash
$ docker exec POTAGE \
  setup_db \
  BASE_URL=https://swift.rc.nectar.org.au:8888/v1/AUTH_33065ff5c34a4652aa2fefb292b3195a/IWGSC_CSS/
```

# License
# User Feedback
## Issues
## Contributing

For information on conributing, please see our [Contribution Guidelines](https://github.com/CroBiA/docker-potage/blob/master/CONTRIBUTING.md).

## Documentation
