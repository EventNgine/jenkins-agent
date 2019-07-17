FROM jenkins/jnlp-slave:3.29-1

USER root
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates software-properties-common 
RUN mkdir /tmp/install

# Key for kubecli
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update
RUN apt-get install -y python3-dev python3-pip  kubectl jq

# Install Helm
ENV HELM_VER 2.14.1

RUN wget https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VER}-linux-amd64.tar.gz -P /tmp/install
RUN tar -zxvf /tmp/install/helm-* -C /tmp/install/
RUN chmod +x /tmp/install/linux-amd64/helm
RUN mv /tmp/install/linux-amd64/helm /usr/local/bin/helm

# Install KOPS
ENV KOPS_VER 1.10.0 

RUN wget https://github.com/kubernetes/kops/releases/download/${KOPS_VER}/kops-linux-amd64 -P /tmp/install
RUN chmod +x /tmp/install/kops-linux-amd64
RUN mv /tmp/install/kops-linux-amd64 /usr/local/bin/kops

RUN rm -Rf /tmp/install
USER jenkins

# Install AWSCLI
ENV AWS_VER 1.16.199
RUN pip3 install awscli==${AWS_VER} --user
