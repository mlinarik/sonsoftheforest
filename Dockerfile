FROM docker.io/mlinarik/steam:latest

# steamcmd is installed to /gamedata by the base image
ENV PATH="/gamedata:${PATH}"

# Copy scripts
COPY scripts/update.sh /gamedata/update.sh
COPY scripts/entrypoint.sh /gamedata/entrypoint.sh
RUN chmod +x /gamedata/update.sh /gamedata/entrypoint.sh

# Seed default config files
COPY defaults/ /defaults/

# Server files and saves are stored in the /data/sof volume at runtime
VOLUME ["/data/sof"]

EXPOSE 8766/udp
EXPOSE 27016/udp
EXPOSE 9700/udp

WORKDIR /gamedata
ENTRYPOINT ["/gamedata/entrypoint.sh"]