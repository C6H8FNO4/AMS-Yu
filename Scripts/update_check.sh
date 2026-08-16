#!/bin/sh

set -e

# ------------------------------------------------------------------
# GitHub API Helpers & Common Functions
# Author: gzk_47
# ------------------------------------------------------------------

# GitHub API Headers (to avoid rate limiting)
API_AUTH="Authorization: Bearer ${GITHUB_TOKEN}"
API_VER="X-GitHub-Api-Version: 2026-03-10"

# Fetch latest releases JSON from GitHub API
fetch_api() {
    API_URL="https://api.github.com/repos/${REPO}/releases"
    curl -H "${API_AUTH}" -H "${API_VER}" -o latest.json -sL "${API_URL}"
}

# Parse version tag from JSON
get_version() {
    TAG=$(jq -r 'first(.[]|select(.assets|any(.name|test("'"${FILE_PATTERN}"'")))).tag_name' latest.json)
    VERSION=$(echo "${TAG}" | sed 's/^v//')
}

# Download matched asset from GitHub release
download_file() {
    DL_URL=$(jq -r 'first(.[]|select(.assets|any(.name|test("'"${FILE_PATTERN}"'")))).assets[] | select(.name|test("'"${FILE_PATTERN}"'")) | .browser_download_url' latest.json)
    curl -sL "${DL_URL}" -o "${APP_NAME}.${END_KEY}"
}

# Check last command result and print status
check_result() {
    if [ $? -ne 0 ]; then
        echo "${APP_NAME} \033[31m❌\033[0m"
    else
        echo "${APP_NAME} \033[32m✅\033[0m"
    fi
}

# ------------------------------------------------------------------
# Version comparison & update logic
# ------------------------------------------------------------------

# Read last processed version for current app from version.json
read_version() {
    LAST_VERSION=$(jq -r --arg app "${APP_NAME}" '.[$app].version // empty' version.json)
    LAST_TAG=$(jq -r --arg app "${APP_NAME}" '.[$app].tag // empty' version.json)
}

# Check if current app has a new version (compare tag with last processed)
has_update() {
    if [ -z "${LAST_TAG}" ]; then
        # No record yet -> treat as new
        return 0
    fi
    if [ "${LAST_TAG}" != "${TAG}" ]; then
        return 0
    fi
    return 1
}

# Record new version into version.json
record_version() {
    jq --arg app "${APP_NAME}" --arg ver "${VERSION}" --arg tag "${TAG}" \
        '.[$app] = {version: $ver, tag: $tag}' version.json > version.json.tmp
    mv version.json.tmp version.json
}

# ------------------------------------------------------------------
# Per-app check & download
# ------------------------------------------------------------------

# Check for update, download if new, record version
# Usage: check_and_download "APP_NAME" "REPO" "FILE_PATTERN" "END_KEY" "TARGET_DIR"
check_and_download() {
    APP_NAME="$1"
    REPO="$2"
    FILE_PATTERN="$3"
    END_KEY="$4"
    TARGET_DIR="$5"

    read_version

    fetch_api
    get_version

    if [ -z "${TAG}" ]; then
        echo "${APP_NAME} \033[31m未找到匹配资产\033[0m"
        return 0
    fi

    if ! has_update; then
        # 若目标文件不存在（如目录变更后首次运行），仍强制下载
        if [ -f "${TARGET_DIR}/${APP_NAME}.${END_KEY}" ]; then
            echo "${APP_NAME} \033[33m已是最新 (${LAST_TAG})\033[0m"
            return 0
        fi
        echo "${APP_NAME} \033[33m已是最新 (${LAST_TAG})，但文件缺失，重新下载\033[0m"
    fi

    mkdir -p "${TARGET_DIR}"
    download_file
    mv "${APP_NAME}.${END_KEY}" "${TARGET_DIR}/"
    check_result
    record_version
}

# ------------------------------------------------------------------
# Working Directory Initialization
# ------------------------------------------------------------------

# Script runs from repository root; resource/ and version.json are relative to it.

# ------------------------------------------------------------------
# Software list
# ------------------------------------------------------------------

# Core suite
check_and_download "Atmosphere" "Atmosphere-NX/Atmosphere" "atmosphere.*[.]zip$" "zip" "resource/base"
check_and_download "Hekate" "easyworld/hekate" "_sc.*[.]zip$" "zip" "resource/base"
check_and_download "Sys-patch" "gzk47/sys-patch" "sys-patch.*[.]zip$" "zip" "resource/base"

# Secondary boot payloads
check_and_download "fusee" "Atmosphere-NX/Atmosphere" "fusee.*[.]bin$" "bin" "resource/base"
check_and_download "Lockpick_RCM" "impeeza/Lockpick_RCMDecScots" "Lockpick_RCM.*[.]bin$" "bin" "resource/Payloads"
check_and_download "TegraExplorer" "zdm65477730/TegraExplorer" "TegraExplorer.*[.]bin$" "bin" "resource/Payloads"
check_and_download "CommonProblemResolver" "zdm65477730/CommonProblemResolver" "CommonProblemResolver.*[.]bin$" "bin" "resource/Payloads"

# Album nro apps
check_and_download "Switch_90DNS_tester" "meganukebmp/Switch_90DNS_tester" "Switch_90DNS_tester.*[.]nro$" "nro" "resource/apps"
check_and_download "DBI" "rashevskyv/dbi" "DBI.*[.]nro$" "nro" "resource/apps"
check_and_download "dbi" "rashevskyv/dbi" "dbi.*[.]config$" "config" "resource/config_default/switch/DBI"
check_and_download "Awoo-Installer" "Huntereb/Awoo-Installer" "Awoo-Installer.*[.]zip$" "zip" "resource/apps"
check_and_download "HekateToolbox" "gzk47/Hekate-Toolbox" "HekateToolbox.*[.]nro$" "nro" "resource/apps"
check_and_download "NX-Activity-Log" "zdm65477730/NX-Activity-Log" "NX-Activity-Log.*[.]nro$" "nro" "resource/apps"
check_and_download "NXThemesInstaller" "exelix11/SwitchThemeInjector" "NXThemesInstaller.*[.]nro$" "nro" "resource/apps"
check_and_download "JKSV" "J-D-K/JKSV" "JKSV.*[.]nro$" "nro" "resource/apps"
check_and_download "Tencent-switcher-gui" "gzk47/Tencent-switcher-GUI" "tencent-switcher-gui.*[.]nro$" "nro" "resource/apps"
check_and_download "Aio-switch-updater" "HamletDuFromage/aio-switch-updater" "aio-switch-updater.*[.]zip$" "zip" "resource/apps"
check_and_download "wiliwili" "xfangfang/wiliwili" "wiliwili-NintendoSwitch.*[.]zip$" "zip" "resource/apps"
check_and_download "SimpleModDownloader" "PoloNX/SimpleModDownloader" "SimpleModDownloader.*[.]nro$" "nro" "resource/apps"
check_and_download "Switchfin" "dragonflylee/Switchfin" "Switchfin.*[.]nro$" "nro" "resource/apps"
check_and_download "Moonlight-Switch" "XITRIX/Moonlight-Switch" "Moonlight-Switch.*[.]nro$" "nro" "resource/apps"
check_and_download "appstore" "fortheusers/hb-appstore" "appstore.*[.]nro$" "nro" "resource/apps"
check_and_download "ReverseNX-Tool" "gzk47/ReverseNX-Tool" "ReverseNX-Tool.*[.]nro$" "nro" "resource/apps"
check_and_download "Goldleaf" "XorTroll/Goldleaf" "Goldleaf.*[.]nro$" "nro" "resource/apps"
check_and_download "Safe_Reboot_Shutdown" "gzk47/Safe_Reboot_Shutdown" "Safe_Reboot_Shutdown.*[.]nro$" "nro" "resource/apps"
check_and_download "Haku33" "StarDustCFW/Haku33" "Haku33.*[.]nro$" "nro" "resource/apps"
check_and_download "linkalho" "impeeza/linkalho" "linkalho.*[.]zip$" "zip" "resource/apps"
check_and_download "Checkpoint" "BernardoGiordano/Checkpoint" "Checkpoint.*[.]nro$" "nro" "resource/apps"
check_and_download "ftpd" "mtheall/ftpd" "ftpd[.]nro$" "nro" "resource/apps"
check_and_download "nxdumptool" "DarkMatterCore/nxdumptool" "nxdt_rw_poc.*[.]nro$" "nro" "resource/apps"
check_and_download "sphaira" "ITotalJustice/sphaira" "sphaira[.]zip$" "zip" "resource/apps"
check_and_download "hbmenu" "switchbrew/nx-hbmenu" "nx-hbmenu.*[.]zip$" "zip" "resource/apps"
check_and_download "hbl" "switchbrew/nx-hbloader" "hbl.*[.]nsp$" "nsp" "resource/apps"

