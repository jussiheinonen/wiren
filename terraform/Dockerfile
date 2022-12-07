FROM amazonlinux
LABEL maintainer="heinonen.jussi@gmail.com"

# Docker image for Terraform
# 
# PULL:  docker pull hashicorp/terraform
#
# BUILD: docker build -t terraform_aws .
#
# RE-TAG: docker tag terraform_aws:<tag> terraform_aws:latest
#
# USAGE: docker run -v "${HOME}/.aws":/root/.aws -v $(pwd):/repo -it terraform_aws:latest


WORKDIR /tmp

RUN yum clean all && yum update && \
    yum install -y yum-utils shadow-utils groff procps && \
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && \
    yum -y install terraform unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install
    
   
ENTRYPOINT ["/bin/bash"] 