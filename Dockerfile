FROM centos:7

LABEL maintainer "Security Onion Solutions, LLC"
LABEL version="SOCtopus v0.1 HH1.0.7"
LABEL description="API for automating SOC-related functions"

RUN yum update -y && yum -y install epel-release
RUN yum -y install https://repo.ius.io/ius-release-el7.rpm https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#RUN yum -y install https://$(rpm -E '%{?centos:centos}%{!?centos:rhel}%{rhel}').iuscommunity.org/ius-release.rpm
RUN yum -y makecache && yum -y install python36u python36u-pip && pip3.6 install --upgrade pip && yum clean all
RUN mkdir -p SOCtopus
ADD ./requirements.txt SOCtopus/
ADD ./app/* SOCtopus/
WORKDIR SOCtopus
RUN pip3.6 install -r requirements.txt
ENTRYPOINT ["python3.6", "SOCtopus.py"]
