FROM debian:10.10-slim

# Default google-fluentd to the latest stable.
# Use `docker build --build-arg REPO_SUFFIX=<CUSTOM_REPO_SUFFIX>` to override
# the version.
ARG REPO_SUFFIX=20230320-1

COPY entrypoint.sh Dockerfile /

# TODO: This may be a moving target, figure out how to pin.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        gnupg2 \
        lsb-release \
        build-essential \
        procps \
        systemd \
        ca-certificates \
        adduser \
    # Install Logging Agent.
    && curl -sS https://dl.google.com/cloudagents/add-logging-agent-repo.sh | REPO_SUFFIX="$REPO_SUFFIX" REPO_CODENAME=stretch DO_NOT_INSTALL_CATCH_ALL_CONFIG=true bash /dev/stdin --also-install \
    # Store versions in the VERSION file.
    && dpkg -s google-fluentd | sed -nE 's/^Version: (.*)(-[^-]+)$/VERSION=\1\nGOOGLE_FLUENTD_VERSION=\1\2/p' >> /VERSION \
    && echo REPO_SUFFIX=$REPO_SUFFIX >> /VERSION \
    && /opt/google-fluentd/embedded/bin/gem list fluent-plugin-google-cloud | sed 's/^fluent-plugin-google-cloud (\(.*\))$/FLUENT_PLUGIN_GOOGLE_CLOUD_VERSION=\1/' >> /VERSION \
    # If any additional gems need to be installed, it should happen before the
    # image cleanup.
    # ==> INSTALL_ADDITIONAL_GEMS_HERE_IF_NEEDED <==
    # Clean up to reduce image size.
    && apt-get purge -y \
        curl \
        lsb-release \
        build-essential \
        gtk2.0 \
        libkrb5-3 \
    && apt-get autoremove -y --purge \
    # Remove docs.
    && rm -rf \
        /usr/share/doc \
        /usr/share/man \
        /opt/google-fluentd/embedded/lib/ruby/gems/*/doc \
        /opt/google-fluentd/embedded/share/doc \
        /opt/google-fluentd/embedded/share/gtk-doc \
        /opt/google-fluentd/embedded/share/man \
        /opt/google-fluentd/embedded/share/terminfo \
    && rm -rf \
        # Cache.
        /var/cache \
        # apt.
        /usr/bin/apt-* \
        /var/lib/apt/lists/* \
        # dpkg.
        /usr/bin/dpkg* \
        /var/lib/dpkg \
        # Temp files.
        /tmp/* \
        # LDAP.
        /usr/lib/x86_64-linux-gnu/libldap* \
        # IBM mainframe / EBCDIC specific encodings.
        /usr/lib/x86_64-linux-gnu/gconv/IBM* \
        /usr/lib/x86_64-linux-gnu/gconv/EBCDIC* \
        # ecpg.
        /opt/google-fluentd/embedded/bin/ecpg \
        # OpenSSL.
        /opt/google-fluentd/embedded/bin/openssl \
        /usr/bin/openssl \
        # Postgres.
        /opt/google-fluentd/embedded/bin/pg_* \
        /opt/google-fluentd/embedded/bin/postgre* \
        /opt/google-fluentd/embedded/share/postgre* \
        /opt/google-fluentd/embedded/lib/postgre* \
        /opt/google-fluentd/embedded/bin/psql \
        # libtool.
        /opt/google-fluentd/embedded/share/libtool \
        /opt/google-fluentd/embedded/bin/libtool \
        # .a files and include libraries.
        /opt/google-fluentd/embedded/include \
        /opt/google-fluentd/embedded/lib/*.a \
    # Log files.
    && find /var/log -name "*.log" -type f -delete \
    # Remove .c .cc .h files.
    && (find /opt/google-fluentd/embedded/ -name '*.c' -o -name '*.cc' -o -name '*.h'  | xargs rm) \
    # Remove unused api client libraries.
    && (find /opt/google-fluentd/embedded/lib/ruby/gems/*/gems/google-api-client-*/generated/google/apis -mindepth 1 -maxdepth 1 \! -name 'logging*' | xargs rm -rf) \
    && sed -i "s/num_threads 8/num_threads 8\n  detect_json true\n  # Enable metadata agent lookups.\n  enable_metadata_agent true\n  metadata_agent_url \"http:\/\/local-metadata-agent.stackdriver.com:8000\"/" "/etc/google-fluentd/google-fluentd.conf"

ENV MALLOC_ARENA_MAX=2

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/google-fluentd"]
