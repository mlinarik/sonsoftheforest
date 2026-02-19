FROM mlinarik/steam

# Install Wine and required dependencies as root
USER root

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        wine \
        wine32 \
        wine64 \
        winbind \
        cabextract \
        wget \
        xvfb \
    && rm -rf /var/lib/apt/lists/*

# Wine's wineserver hardcodes P_tmpdir (/tmp) for its socket tmpfile and uses
# O_TMPFILE, which fails on overlayfs.  Replace /tmp with a symlink to /dev/shm
# which is always a real tmpfs in every container runtime.
RUN rm -rf /tmp && ln -s /dev/shm /tmp

# Server install dir and data dir
RUN mkdir -p /server /data

# Copy helper scripts and default config seeds
COPY scripts/update.sh /scripts/update.sh
COPY scripts/entrypoint.sh /scripts/entrypoint.sh
RUN chmod +x /scripts/update.sh /scripts/entrypoint.sh

COPY defaults/ /defaults/

# Exposed ports (all UDP per Endnight documentation)
EXPOSE 8766/udp
EXPOSE 27016/udp
EXPOSE 9700/udp

VOLUME ["/data"]

ENTRYPOINT ["/scripts/entrypoint.sh"]
