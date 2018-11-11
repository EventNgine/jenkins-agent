FROM jenkins/jnlp-slave:3.10-1

USER root
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates software-properties-common 

# Key for kubecli
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update
RUN apt-get install -y python-dev python-pip  kubectl 


# Install AWSCLI
ENV AWS_VER 1.11.84

RUN pip install awscli==${AWS_VER}


# Install Helm
ENV HELM_VER 2.10.0

RUN wget https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VER}-linux-amd64.tar.gz -P /tmp/
RUN tar -zxvf /tmp/helm-* -C /tmp/
RUN chmod +x /tmp/linux-amd64/helm
RUN mv /tmp/linux-amd64/helm /usr/local/bin/helm


# Install KOPS
ENV KOPS_VER 1.10.0 

RUN wget https://github.com/kubernetes/kops/releases/download/${KOPS_VER}/kops-linux-amd64 -P /tmp/
RUN ls -alh /tmp/
RUN chmod +x /tmp/kops-linux-amd64
RUN mv /tmp/kops-linux-amd64 /usr/local/bin/kops


# Clean up
RUN rm -Rf /tmp/
USER jenkins
