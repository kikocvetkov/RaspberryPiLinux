set -e

# Check if a parameter was provided
if [ -z "$1" ]; then
    echo "No storage selected, aborting"
    exit 1
fi

kas shell -c "bitbake -c clean my-cpp-app" kas-rpi3.yml
kas build kas-rpi3.yml
cd build/tmp/deploy/images/raspberrypi3

DEVICE="$1"

echo "This will overwrite $DEVICE with zeros!"
read -p "Are you sure? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Aborted."
    exit 1
fi

sudo dd if=/dev/zero of="$DEVICE" bs=8192 count=65536 status=progress
sudo dd if=core-image-full-cmdline-raspberrypi3.rpi-sdimg of="$DEVICE" bs=8192