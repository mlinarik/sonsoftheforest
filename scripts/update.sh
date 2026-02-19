#!/bin/bash
set -e

INSTALL_DIR="/data/sof"
# Steam App ID for Sons of the Forest Dedicated Server
APP_ID="2465200"

echo "[update] Installing / updating Sons of the Forest Dedicated Server (AppID ${APP_ID})..."

# Run steamcmd once to ensure it is fully initialised before installing the app.
# A fresh steamcmd install can return "Missing configuration" on the first real run.
steamcmd.sh +quit

steamcmd.sh \
    +force_install_dir "${INSTALL_DIR}" \
    +login anonymous \
    +app_update "${APP_ID}" validate \
    +quit

echo "[update] Server files are up to date."
