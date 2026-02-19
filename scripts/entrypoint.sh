#!/bin/bash
set -e

INSTALL_DIR="/server"
DATA_DIR="/data"
USERDATA_DIR="${DATA_DIR}/userdata"
WINEPREFIX_DIR="${DATA_DIR}/wineprefix"

export WINEPREFIX="${WINEPREFIX_DIR}"
export WINEDEBUG="-all"
export WINEDLLOVERRIDES="mscoree,mshtml="

# Wine/wineserver requires XDG_RUNTIME_DIR to be a writable directory.
# Without it, wineserver cannot create its tmpdir socket file.
export XDG_RUNTIME_DIR="/tmp/runtime-$(id -u)"
mkdir -p "${XDG_RUNTIME_DIR}"
chmod 0700 "${XDG_RUNTIME_DIR}"

# ----- First-run Wine prefix initialisation -----
if [ ! -d "${WINEPREFIX_DIR}/drive_c" ]; then
    echo "[entrypoint] Initialising Wine prefix at ${WINEPREFIX_DIR}..."
    mkdir -p "${WINEPREFIX_DIR}"
    wineboot --init
    echo "[entrypoint] Wine prefix ready."
fi

# ----- Install / update the server -----
/scripts/update.sh

# ----- Seed default config files from the image if not already present -----
mkdir -p "${USERDATA_DIR}"

if [ ! -f "${USERDATA_DIR}/dedicatedserver.cfg" ]; then
    echo "[entrypoint] No dedicatedserver.cfg found – copying default from image."
    cp /defaults/dedicatedserver.cfg "${USERDATA_DIR}/dedicatedserver.cfg"
fi

if [ ! -f "${USERDATA_DIR}/ownerswhitelist.txt" ]; then
    echo "[entrypoint] No ownerswhitelist.txt found – copying default from image."
    cp /defaults/ownerswhitelist.txt "${USERDATA_DIR}/ownerswhitelist.txt"
fi

# ----- Start the server -----
# -userdatapath accepts a Windows-style path; Z: maps to / inside Wine.
USERDATA_WIN="Z:${USERDATA_DIR}"

echo "[entrypoint] Starting Sons of the Forest Dedicated Server..."
echo "[entrypoint]   Install dir : ${INSTALL_DIR}"
echo "[entrypoint]   Userdata    : ${USERDATA_WIN}"
echo "[entrypoint]   Wine prefix : ${WINEPREFIX_DIR}"

cd "${INSTALL_DIR}"
exec wine SonsOfTheForestDS.exe -userdatapath "${USERDATA_WIN}"
