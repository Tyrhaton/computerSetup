#!/bin/bash
# Fingerprint sensor setup for ASUS Vivobook 16X K3605ZU
# Sensor: ELAN Match-on-Chip 2 (USB 04f3:0c90), embedded in the touchpad.
# Not supported by upstream/Ubuntu libfprint. Uses the community elanmoc2
# driver from Depau's libfprint fork, branch elanmoc2-working (tested at
# commit 3d489eb; the newer elanmoc2 branch fails enrollment on 0c90 with
# "transfer timed out"), with 0c90 added to the driver's device ID table.

set -e

sudo apt update
sudo apt install -y build-essential git meson ninja-build pkg-config \
  libglib2.0-dev libgusb-dev libgudev-1.0-dev libnss3-dev libpixman-1-dev \
  libcairo2-dev fprintd libpam-fprintd

cd ~/Downloads
rm -rf libfprint-elanmoc2
git clone --branch elanmoc2-working --depth 1 \
  https://gitlab.freedesktop.org/Depau/libfprint.git libfprint-elanmoc2
cd libfprint-elanmoc2

# Add the 0c90 device ID to the driver's ID table (same protocol as 0c00/0c4c)
grep -q '0x0c90' libfprint/drivers/elanmoc2/elanmoc2.h || \
  sed -i '/0x0c5e/a\  {.vid = ELANMOC2_VEND_ID, .pid = 0x0c90, .driver_data = ELANMOC2_ALL_DEV},' \
    libfprint/drivers/elanmoc2/elanmoc2.h

# Install to /usr/local so it shadows the system libfprint via ldconfig;
# the Ubuntu package stays untouched (see README.md for rollback)
meson setup builddir --prefix=/usr/local -Ddoc=false -Dintrospection=false \
  -Dgtk-examples=false -Dinstalled-tests=false
meson compile -C builddir
sudo meson install -C builddir
sudo ldconfig

sudo systemctl restart fprintd.service

# Fingerprint for sudo/login/lock screen, password stays as fallback
sudo pam-auth-update --enable fprintd

echo ""
echo "Enrollment takes 8 touches. Keep tapping continuously (press ~1s, lift,"
echo "repeat) without pausing - the driver aborts if more than ~10s passes"
echo "between touches."
echo ""
fprintd-enroll -f right-index-finger "$USER"

echo ""
echo "Touch the sensor once more to test:"
fprintd-verify "$USER"
