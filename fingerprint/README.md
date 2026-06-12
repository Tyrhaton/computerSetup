# Fingerprint sensor (ASUS Vivobook 16X K3605ZU)

ELAN Match-on-Chip 2 sensor (USB `04f3:0c90`) in the touchpad. Not supported by
upstream/Ubuntu libfprint, so `installFingerprintDriver.sh` builds Depau's
community `elanmoc2` driver (branch `elanmoc2-working` + the 0c90 device ID
patched in) and installs it to `/usr/local`, shadowing the system library.
Then it enables PAM fingerprint auth (password stays as fallback) and enrolls
the right index finger.

## Quirks

- **Enrollment:** keep tapping continuously, don't wait for feedback between
  touches. The driver has a 10s USB timeout between touches and aborts the
  whole enrollment ("transfer timed out" / `enroll-unknown-error`) if you pause.
- More fingers can be enrolled later via Settings → System → Users →
  Fingerprint Login, or `fprintd-enroll -f <finger> $USER`.
- If the sensor misbehaves after suspend/resume: `sudo systemctl restart fprintd`.
- Ubuntu updates of libfprint are harmless: the `/usr/local` build keeps
  precedence via ldconfig.

## Rollback

```bash
sudo rm /usr/local/lib/x86_64-linux-gnu/libfprint-2.so*
sudo ldconfig
sudo apt install --reinstall libfprint-2-2   # also restores the udev rules file
```
