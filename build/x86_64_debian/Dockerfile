FROM debian:9

RUN apt-get -y update \
 && apt-get -y install \
        # Needed for gpg2 and rvm installation.
        curl \
        gnupg2 \
        linux-libc-dev \
        procps \
        # Needed for agent build.
        autoconf \
        bzip2 \
        fakeroot \
        git \
        g++ \
        make \
        ruby \
        xz-utils \
 # RVM GPG keys.
 && mkdir -p ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
 && gpg2 --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
 # Install RVM.
 && curl -sSL -o get-rvm-io.sh https://get.rvm.io \
 && (echo "7bbf79be95e516f72945e558a4290b40ff8714158140a00991d42172ff78e209  get-rvm-io.sh" | sha256sum --check) \
 && /bin/bash get-rvm-io.sh stable \
 && rm -f get-rvm-io.sh \
 # RVM requires running in a login shell.
 && /bin/bash -l -c "rvm requirements && rvm install 3.1.2 && gem install bundler --no-document && gem update --no-document" \
 && apt-get -y clean
