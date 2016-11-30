# Building a Docker Container for POTAGE
 
First, get the `Dockerfile` code repository.

```bash
git clone --recursive git@code.acpfg.local:nhaigh/Dockerfiles.git
```

Now lets build the `potage` container using the `Dockerfile`:

```bash
cd Dockerfiles/potage
docker build --tag nathanhaigh/potage ./
```

# Generate the data required by POTAGE

```bash
BLAST_DB_DIR='potage_data/blast_db/'
urls=(
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/1AL_v2-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/1AS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/1BL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/1BS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/1DL-ab-k95-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/1DS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/2AL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/2AS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/2BL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/2BS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/2DL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/2DS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/3AL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/3AS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/3B-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/3DL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/3DS-ab-k95-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/4AL_v2-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/4AS_v2-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/4BL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/4BS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/4DL_v3-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/4DS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/5AL-ab-k95-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/5AS-ab-k95-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/5BL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/5BS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/5DL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/5DS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/6AL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/6AS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/6BL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/6BS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/6DL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/6DS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/7AL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/7AS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/7BL-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/7BS-ab-k71-contigs.fa.longerthan_200.fa.gz
https://urgi.versailles.inra.fr/download/iwgsc/Survey_sequence/7DL-ab-k71-contigs.fa.longerthan_200.fa.gz
)
for url in "${urls[@]}"
  file=${url##*/}
  chr_arm="${file//[-_]*}"
  curl "${url}" | gunzip | sed "s/^>/>${chr_arm}_/" | makeblastdb -in - -dbtype nucl -title "${file}" -parse_seqids -out "${BLAST_DB_DIR-./}${file}"
done

# Aggregate BLAST DB's into a single DB using an alias
# get the list of db's to aggregate
DBS=$( ls -1 ${BLAST_DB_DIR-./}*.fa.gz.* | sed 's/\.[^\.]*$//' | sort -u )
blastdb_aliastool -dblist "$DBS" -dbtype nucl \
  -out "${BLAST_DB_DIR-./}IWGSC_SS" -title "IWGSC Chromosomal Survey Sequences"
```

# Running the Container
 
We will map the host's port `80` to the container's port `8080`. We'll also run the container in `detached` mode.

```bash
docker run \
  --detach \
  --publish 80:8080 \
  --volume "$(pwd)/potage_data:/var/tomcat/persist/potage_data:ro" \
  --volume "$(pwd)/potage_data/visits.txt:/var/tomcat/persist/potage_data/visits.txt" \
  nathanhaigh/potage
```

# Publish the container to Docker Hub

```bash
docker login --username nathanhaigh
docker push nathanhaigh/potage
``

