#!/bin/sh
curl -sL 'https://api.github.com/repos/C6H8FNO4/Nintendo-FW-UPDATE/releases/latest' -o /tmp/fw_latest.json
jq -r '.name' /tmp/fw_latest.json
jq -r '.assets[] | .name + " | " + (.size|tostring) + " bytes | " + .browser_download_url' /tmp/fw_latest.json
