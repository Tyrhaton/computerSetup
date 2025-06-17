#!/bin/bash
CRON_JOB="0 1 * * * ~/.delete_old_downloads.sh"
crontab -l 2>/dev/null | grep -F "$CRON_JOB" >/dev/null || \
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
