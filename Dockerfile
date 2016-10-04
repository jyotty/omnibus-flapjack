FROM ubuntu:trusty

RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    libssl-dev \
    libyaml-dev \
    libreadline-dev \
    libxslt1-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libexpat1-dev \
    libicu-dev \
    cmake

RUN git config --global user.email "docker@flapjack.io" && \
    git config --global user.name "Flapjack Docker Packager"

RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
RUN /usr/local/rbenv/plugins/ruby-build/install.sh
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> .bashrc
RUN rbenv install 2.3.1
RUN rbenv global 2.3.1
RUN gem install bundler --no-ri --no-rdoc

RUN curl -o /tmp/go1.7.1.linux-amd64.tar.gz https://storage.googleapis.com/golang/go1.7.1.linux-amd64.tar.gz && \
    [ "43ad621c9b014cde8db17393dc108378d37bc853aa351a6c74bf6432c1bbd182" = "$(sha256sum /tmp/go1.7.1.linux-amd64.tar.gz| cut -d' '  -f1)" ] && \
    tar -C /usr/local -xzf /tmp/go1.7.1.linux-amd64.tar.gz && \
    echo "PATH=$PATH:/usr/local/go/bin" | tee /etc/profile.d/go.sh

RUN git config --global user.email "docker@flapjack.io" && \
    git config --global user.name "Flapjack Docker Packager"

RUN git clone https://github.com/jyotty/omnibus-flapjack.git && \
    cd omnibus-flapjack && \
    bundle install --binstubs

