#!/bin/bash
set -e

INSTALL_DIR="/server"
# Steam App ID for Sons of the Forest Dedicated Server
APP_ID="2465200"

echo "[update] Installing / updating Sons of the Forest Dedicated Server (AppID ${APP_ID})..."

steamcmd \
    +force_install_dir "${INSTALL_DIR}" \
    +login anonymous \
    +app_update "${APP_ID}" validate \
    +quit

echo "[update] Server files are up to date."
