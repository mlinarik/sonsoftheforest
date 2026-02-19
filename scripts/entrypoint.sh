#!/bin/bash
set -e

INSTALL_DIR="/data/sof"
USERDATA_DIR="${INSTALL_DIR}/userdata"

# ----- Ensure install dir exists and is writable -----
mkdir -p "${INSTALL_DIR}"
chmod 755 "${INSTALL_DIR}"

# ----- Install / update the server -----
/gamedata/update.sh

# ----- Seed default config files from the image if not already present -----
mkdir -p "${USERDATA_DIR}"
chmod 755 "${USERDATA_DIR}"

if [ ! -f "${USERDATA_DIR}/dedicatedserver.cfg" ]; then
    echo "[entrypoint] No dedicatedserver.cfg found – copying default from image."
    cp /defaults/dedicatedserver.cfg "${USERDATA_DIR}/dedicatedserver.cfg"
fi

if [ ! -f "${USERDATA_DIR}/ownerswhitelist.txt" ]; then
    echo "[entrypoint] No ownerswhitelist.txt found – copying default from image."
    cp /defaults/ownerswhitelist.txt "${USERDATA_DIR}/ownerswhitelist.txt"
fi

# ----- Start the server -----
echo "[entrypoint] Starting Sons of the Forest Dedicated Server..."
echo "[entrypoint]   Install dir : ${INSTALL_DIR}"
echo "[entrypoint]   Userdata    : ${USERDATA_DIR}"

cd "${INSTALL_DIR}"
exec ./SonsOfTheForestDS -userdatapath "${USERDATA_DIR}"
