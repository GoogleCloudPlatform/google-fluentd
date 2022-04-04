FROM centos:6

# CentOS 6 is EOL, so we have to switch to the vault repos.
RUN sed -i \
        -e 's%^mirrorlist%#mirrorlist%' \
        -e 's%^# *baseurl=http://mirror%baseurl=http://vault%' \
        /etc/yum.repos.d/CentOS-*.repo

RUN yum -y install \
        # Needed for gpg2 and rvm installation.
        curl \
        ca-certificates \
        # Needed for agent build.
        autoconf \
        bzip2 \
        centos-release-SCL \
        expect \
        gcc-c++ \
        git \
        glibc-devel \
        patch \
        redhat-lsb-core \
        rpm-build \
        rpm-sign \
        ruby \
        which \
        zlib-devel \
 # Do this again, since centos-release-SCL adds another repo.
 && sed -i \
        -e 's%^mirrorlist%#mirrorlist%' \
        -e 's%^# *baseurl=http://mirror%baseurl=http://vault%' \
        /etc/yum.repos.d/CentOS-*.repo \
 # CentOS 6 comes with git 1.7.1, and omnibus requires at least 1.7.2.
 && rpm -ivh http://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm \
 && yum --enablerepo=rpmforge-extras -y upgrade git \
 # RVM GPG keys.
 && mkdir -p ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
 && gpg2 --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
 && curl -sSL -o get-rvm-io.sh https://get.rvm.io \
 && (echo "fea24461e98d41528d6e28684aa4c216dbe903869bc3fcdb3493b6518fae2e7e  get-rvm-io.sh" | sha256sum --check) \
 && /bin/bash get-rvm-io.sh stable \
 && rm -f get-rvm-io.sh \
 # RVM requires running in a login shell.
 # Force RVM to link in a newer openssl version.
 && /bin/bash -l -c 'sed -i "/openssl_version/s/1.0.1i/1.0.1n/" $rvm_path/config/db && rvm pkg install openssl' \
 && /bin/bash -l -c 'rvm requirements && rvm install 2.5.3 --with-openssl-dir=$rvm_path/usr && gem install bundler --no-document && gem update' \
 && yum -y clean all
