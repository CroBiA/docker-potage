FROM tomcat:8.0
LABEL authors="Nathan S. Watson-Haigh, Radoslaw Suchecki"

# install system-wide deps
RUN apt-get update && apt-get install -y \
  ant \
  make \
  ncbi-blast+ \
  openjdk-7-jdk \
 && rm -rf /var/lib/apt/lists/*

# Copy the application code
COPY potage /opt/potage

# Build POTAGE using a custom build file
COPY build.xml /opt/potage/
WORKDIR /opt/potage
RUN ant

# Deploy POTAGE webapp
RUN mv /opt/potage/dist/potage.war /usr/local/tomcat/webapps/

# Setup POTAGE data directory
RUN mkdir -p /var/tomcat/persist/potage_data/blast_db
COPY potage_data /var/tomcat/persist/potage_data

# Setup scripts for creating BLAST DB
COPY setup_db Makefile /opt/potage/
ENV PATH /opt/potage/:$PATH

# expose port
EXPOSE 8080

# start app
CMD [ "catalina.sh", "run" ]
