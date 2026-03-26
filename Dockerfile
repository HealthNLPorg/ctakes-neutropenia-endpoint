# syntax=docker/dockerfile:1.4
FROM redhat/ubi9
LABEL description="DeepPhe-Neutropenia Image"

# Set Maven version to be installed
ARG MAVEN_VERSION=3.8.6
ARG ARTEMIS_VERSION=2.51.0

WORKDIR /usr/src/app

# Copy everything else from host to image
COPY . .

# When trying to run "dnf updates" or "dnf install" the "system is not registered with an entitlement server" error message is given
# To fix this issue:
# When following option is set to 1, then all repositories defined outside redhat.repo will be disabled\n\
# every time subscription-manager plugin is triggered by dnf or dnf\n\
# >> /etc/dnf/pluginconf.d/subscription-manager.conf

# Reduce the number of layers in image by minimizing the number of separate RUN commands
# Update packages
# Install the prerequisites
# Install which (otherwise 'mvn version' prints '/usr/share/maven/bin/mvn: line 93: which: command not found') and Java 17 via dnf repository
# Download Maven tar file and install
# Install GCC, Git, Python 3.10, libraries needed for Python development
# Set default Python version for `python` command, `python3` already points to the newly installed Python3.11
# Upgrade pip, after upgrading, both pip and pip3 are the same version
# Download ActiveMQ Artemis ARTEMIS_VERSION zip and extract. The final path: /usr/src/app/apache-artemis-ARTEMIS_VERSION
# Create the Artemis broker 'mybroker'
# Clean all dnf cache
RUN --mount=type=cache,target=/var/cache/dnf dnf upgrade -y && \
    dnf install -y which unzip java-17-openjdk java-17-openjdk-devel && \
    dnf install -y git python3.12 python3.12-pip && \
    ln -fs /usr/bin/python3.12 /usr/bin/python
    # dnf install -y git python3.11 python3.11-pip && \
    # ln -fs /usr/bin/python3.11 /usr/bin/python

# RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz |
RUN tar xzf apache-maven-3.8.6-bin.tar.gz -C /usr/share && \
    mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN python -m pip install -U pip
# RUN --mount=type=cache,target=/root/.cache pip install -r requirements.txt

# RUN curl -LO https://archive.apache.org/dist/artemis/artemis/2.51.0/apache-artemis-2.51.0-bin.zip && \
RUN	unzip apache-artemis-2.51.0-bin.zip && \
	apache-artemis-2.51.0/bin/artemis create mybroker --user deepphe --password deepphe --allow-anonymous
# RUN unzip apache-artemis-2.51.0-bin.zip && \
WORKDIR /usr/src/app/neutropenia

# Set environment variables for Java and Maven
ENV JAVA_HOME /usr/lib/jvm/java
ENV M2_HOME /usr/share/maven
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH

RUN --mount=type=cache,target=/root/.m2 mvn clean package
# RUN python tests.py
CMD ["java", "-cp", "target/ctakes-neutropenia-endpoint-7.0.0-SNAPSHOT-jar-with-dependencies.jar", "org.apache.ctakes.core.pipeline.PiperFileRunner", "-p", "org/apache/ctakes/neutropenia/pipeline/ClingenAnnotator", "-i", "/usr/src/app/input", "-o", "/usr/src/app/output", "-a", "/usr/src/app/mybroker", "-v", "/usr/bin/python"]


