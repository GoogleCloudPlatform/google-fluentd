FROM centos:7

RUN yum -y install \
        # Needed for gpg2 and rvm installation.
        curl \
        ca-certificates \
        # Needed for agent build.
        autoconf \
        bzip2 \
        expect \
        gcc-c++ \
        git \
        patch \
        rpm-build \
        rpm-sign \
        ruby \
        which \
        zlib-devel \
 # RVM GPG keys.
 && mkdir -p ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
 && gpg2 --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
 && curl -sSL -o get-rvm-io.sh https://get.rvm.io \
 && (echo "fea24461e98d41528d6e28684aa4c216dbe903869bc3fcdb3493b6518fae2e7e  get-rvm-io.sh" | sha256sum --check) \
 && /bin/bash get-rvm-io.sh stable \
 && rm -f get-rvm-io.sh \
 # RVM requires running in a login shell.
 && /bin/bash -l -c "rvm requirements && rvm install 2.5.3 && gem install bundler --no-document && gem update" \
 && yum -y clean all
