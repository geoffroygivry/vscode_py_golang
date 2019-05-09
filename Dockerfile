# the base miniconda3 image
FROM continuumio/miniconda3:latest

# load in the environment.yml file - this file controls what Python packages we install
ADD environment.yml /

# install the Python packages we specified into the base environment
RUN conda update -n base conda -y && conda env update

# declaring Go versions
ARG GO_MAJOR=1
ARG GO_MINOR=12
ARG GO_PATCH=5


ENV GO_MAJOR=${GO_MAJOR}
ENV GO_MINOR=${GO_MINOR}
ENV GO_PATCH=${GO_PATCH}


# installing Go
RUN wget -P /tmp/ \
    https://dl.google.com/go/go${GO_MAJOR}.${GO_MINOR}.${GO_PATCH}.linux-amd64.tar.gz &&\
    tar -C /tmp -xvzf /tmp/go${GO_MAJOR}.${GO_MINOR}.${GO_PATCH}.linux-amd64.tar.gz &&\
    mv /tmp/go /usr/local &&\
    rm -vf /tmp/* &&\
    mkdir $HOME/work && echo "export GOPATH=$HOME/work" >> ~/.bashrc &&\
    echo "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin" >> ~/.bashrc

# download the coder binary, untar it, and allow it to be executed
RUN wget https://github.com/cdr/code-server/releases/download/1.939-vsc1.33.1/code-server1.939-vsc1.33.1-linux-x64.tar.gz \
    && tar -xzvf code-server1.939-vsc1.33.1-linux-x64.tar.gz && chmod +x code-server1.939-vsc1.33.1-linux-x64/code-server

COPY docker-entrypoint.sh /usr/local/bin/

ADD ./code /code

ENTRYPOINT ["docker-entrypoint.sh"]