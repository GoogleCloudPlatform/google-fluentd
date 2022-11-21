FROM opensuse/leap:42.3

RUN zypper modifyrepo -d 'OSS Update' \
 && zypper ar http://opensuse.ucom.am/update/leap/42.3/oss/ 'OSS Update Mirror' \
 && zypper -n refresh \
 && zypper -n install \
        # Needed for gpg2 and rvm installation.
        curl \
        # Needed for agent build.
        autoconf \
        bzip2 \
        expect \
        gcc-c++ \
        git \
        patch \
        ruby \
        rpm-build \
        which \
        zlib-devel \
        xz \
 # RVM GPG keys.
 && mkdir -p ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
 && gpg2 --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
 # Remove expired root certificate.
 && mv /var/lib/ca-certificates/pem/DST_Root_CA_X3.pem /etc/pki/trust/blacklist/ \
 && update-ca-certificates \
 && curl -sSL -o get-rvm-io.sh https://get.rvm.io \
 && (echo "fea24461e98d41528d6e28684aa4c216dbe903869bc3fcdb3493b6518fae2e7e  get-rvm-io.sh" | sha256sum --check) \
 && /bin/bash get-rvm-io.sh stable \
 && rm -f get-rvm-io.sh \
 # RVM requires running in a login shell.
 && /bin/bash -l -c "rvm requirements && rvm install 2.7.6 && gem install bundler --no-document && gem update" \
 # Pretend we're on SLES 12.
 && /bin/sed -i -e 's/VERSION = 42.3/VERSION = 12/' /etc/SuSE-release \
 && /bin/sed -i -e 's/VERSION="42.3"/VERSION="12-SP3"/' -e 's/VERSION_ID="42.3"/VERSION_ID="12.3"/' /etc/os-release \
 && zypper -n clean
