FROM tomcat:8.0
LABEL authors="Nathan S. Watson-Haigh, Radoslaw Suchecki"

# install system-wide deps
RUN apt-get update && apt-get install -y \
  ant \
  make \
  ncbi-blast+ \
  openjdk-7-jdk \
 && rm -rf /var/lib/apt/lists/*

# Get application code and dependencies
COPY potage /opt/potage
RUN mkdir -p /opt/potage/web/WEB-INF/lib/ && \
  wget -cP /opt/potage/web/WEB-INF/lib/ http://search.maven.org/remotecontent?filepath=org/primefaces/primefaces/6.0/primefaces-6.0.jar && \
  wget -cP /opt/potage/web/WEB-INF/lib/ https://maven.java.net/content/repositories/releases/org/glassfish/javax.faces/2.2.8/javax.faces-2.2.8.jar && \
  wget -cP /opt/potage/web/WEB-INF/lib/ http://search.maven.org/remotecontent?filepath=org/glassfish/javax.el/3.0.1-b08/javax.el-3.0.1-b08.jar && \
  wget -cP /opt/potage/web/WEB-INF/lib/ http://search.maven.org/remotecontent?filepath=org/apache/poi/poi/3.16-beta1/poi-3.16-beta1.jar && \
  wget -cP /opt/potage/web/WEB-INF/lib/ http://search.maven.org/remotecontent?filepath=org/jetbrains/kotlin/kotlin-runtime/1.0.5-2/kotlin-runtime-1.0.5-2.jar && \
  wget -cP /opt/potage/web/WEB-INF/lib/ http://repository.primefaces.org/org/primefaces/themes/smoothness/1.0.10/smoothness-1.0.10.jar && \
  wget -cP /opt/potage/web/WEB-INF/lib/ http://search.maven.org/remotecontent?filepath=org/mapdb/mapdb/2.0-beta13/mapdb-2.0-beta13.jar && \
  wget -cP /tmp/ http://www.java2s.com/Code/JarDownload/javax.servlet/javax.servlet-3.0.0.v201112011016.jar.zip && \
  unzip /tmp/javax.servlet-3.0.0.v201112011016.jar.zip -d /opt/potage/web/WEB-INF/lib/ && rm /tmp/javax.servlet-3.0.0.v201112011016.jar.zip

# Build
COPY build.xml /opt/potage/
WORKDIR /opt/potage
RUN ant

# Deploy
RUN cp /opt/potage/dist/potage.war /usr/local/tomcat/webapps/

RUN mkdir -p /var/tomcat/persist/potage_data/blast_db /var/tomcat/persist/potage_data/FPKMs/reordered
COPY potage_data /var/tomcat/persist/potage_data
COPY Makefile /var/tomcat/persist/potage_data/

# expose port
EXPOSE 8080

# start app
CMD [ "catalina.sh", "run" ]
