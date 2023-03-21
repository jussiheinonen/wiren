FROM amazonlinux
LABEL maintainer="heinonen.jussi@gmail.com"

# Docker image for Terraform
# 
# PULL:  docker pull amazonlinux
#
# BUILD: docker build -t terraform_aws .
#
# RE-TAG: docker tag terraform_aws:<tag> terraform_aws:latest
#
# USAGE: docker run -v "${HOME}/.aws":/root/.aws -v $(pwd):/repo -it terraform_aws:latest


WORKDIR /tmp

RUN yum clean all 
#RUN yum update 
RUN yum install -y yum-utils shadow-utils groff procps python3 less
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
RUN yum -y install terraform unzip
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN    unzip awscliv2.zip && \
    ./aws/install
    
   
ENTRYPOINT ["/bin/bash"] 