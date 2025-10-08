#!/bin/bash
# ==============================================================
# Yocto setup script for Raspberry Pi project
# ==============================================================
# This script initializes the Yocto build environment,
# adds necessary layers, and builds the selected image.
# ==============================================================

set -e  # Exit on any error

# --- Configuration ---
YOCTO_DIR="$(dirname "$(realpath "$0")")/.."
BUILD_DIR="$YOCTO_DIR/build"
MACHINE="raspberrypi3"
IMAGE="${1:-core-image-minimal}"  # Argument or default

# --- Environment Setup ---
cd "$YOCTO_DIR"
source poky/oe-init-build-env "$BUILD_DIR"

# --- Add layers if not already added ---
bitbake-layers show-layers | grep -q "meta-raspberrypi" || \
    bitbake-layers add-layer ../meta-raspberrypi

# --- Configure build ---
CONF_FILE="$BUILD_DIR/conf/local.conf"

# Replace existing MACHINE line, or add it if missing
if grep -q '^MACHINE' "$CONF_FILE"; then
    sed -i "s/^MACHINE.*/MACHINE = \"$MACHINE\"/" "$CONF_FILE"
else
    echo "MACHINE = \"$MACHINE\"" >> "$CONF_FILE"
fi

# --- Build image ---
echo "Starting Yocto build for $MACHINE ($IMAGE)..."
bitbake "$IMAGE"
