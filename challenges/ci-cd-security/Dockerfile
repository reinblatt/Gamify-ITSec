FROM jenkins/jenkins:lts

USER root

# Install necessary tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Jenkins plugins
RUN jenkins-plugin-cli --plugins \
    git \
    workflow-job \
    workflow-aggregator \
    credentials \
    credentials-binding \
    plain-credentials \
    pipeline-model-definition

# Copy challenge configuration
COPY jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml

# Set proper permissions
RUN chown -R jenkins:jenkins /var/jenkins_home

USER jenkins

# Set environment variables
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Djenkins.model.Jenkins.slaveAgentPort=50000"
ENV JENKINS_HOME="/var/jenkins_home"
ENV CASC_JENKINS_CONFIG="/usr/share/jenkins/ref/jenkins.yaml"

EXPOSE 8080 50000 