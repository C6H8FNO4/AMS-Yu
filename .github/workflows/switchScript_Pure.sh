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
fetch_api_latest() {
    API_URL="https://api.github.com/repos/${REPO}/releases/latest"
    curl -H "${API_AUTH}" -H "${API_VER}" -o latest.json -sL "${API_URL}"
}

# Parse version tag from JSON and write to description
get_version() {
    VERSION=$(jq -r 'first(.[]|select(.assets|any(.name|test("'"${FILE_PATTERN}"'")))).tag_name' latest.json | sed 's/^v//')
    echo "${APP_NAME} ${VERSION}" >> ../description.txt
}
get_version_latest() {
    VERSION=$(jq -r '.tag_name' latest.json | sed 's/^v//')
    echo "${APP_NAME} ${VERSION}" >> ../description.txt
}

# Download matched asset from GitHub release
download_file() {
    DL_URL=$(jq -r 'first(.[]|select(.assets|any(.name|test("'"${FILE_PATTERN}"'")))).assets[] | select(.name|test("'"${FILE_PATTERN}"'")) | .browser_download_url' latest.json)
    curl -sL "${DL_URL}" -o "${APP_NAME}.${END_KEY}"
}
download_file_latest() {
    DL_URL=$(jq -r '.assets[] | select(.name|test("'"${FILE_PATTERN}"'")) | .browser_download_url' latest.json)
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

# Unzip package and remove archive
unzip_and_clean() {
    unzip -oq "${APP_NAME}.${END_KEY}"
    rm -f "${APP_NAME}.${END_KEY}"
}

# Create directory and move file to target directory
move_to_dir() {
    mkdir -p "${1}"
    mv "${APP_NAME}.${END_KEY}" "${1}"
}

# ------------------------------------------------------------------
# Working Directory Initialization
# ------------------------------------------------------------------

WORK_DIR="AMS-Pure"

if [ -d "${WORK_DIR}" ]; then
  rm -rf "${WORK_DIR}"
fi
if [ -e description.txt ]; then
  rm -rf description.txt
fi
mkdir -p "${WORK_DIR}"
mkdir -p "${WORK_DIR}/atmosphere/config"
mkdir -p "${WORK_DIR}/atmosphere/hosts"
mkdir -p "${WORK_DIR}/bootloader/ini"
mkdir -p "${WORK_DIR}/config/JKSV"
mkdir -p "${WORK_DIR}/config/sphaira"
#mkdir -p "${WORK_DIR}/emuiibo/overlay"

cd "${WORK_DIR}"

# ------------------------------------------------------------------


cat >> ../description.txt << ENDOFFILE
大气层核心套件：
 
ENDOFFILE

# ==================================================================
APP_NAME="Atmosphere"
REPO="Atmosphere-NX/Atmosphere" FILE_PATTERN="atmosphere.*[.]zip$" END_KEY="zip"
# ==================================================================
fetch_api; get_version
download_file; check_result; unzip_and_clean

# ==================================================================
APP_NAME="fusee"
REPO="Atmosphere-NX/Atmosphere" FILE_PATTERN="fusee.*[.]bin$" END_KEY="bin"
# ==================================================================
fetch_api; # get_version
download_file; check_result; move_to_dir ./bootloader/payloads

# ==================================================================
APP_NAME="Hekate"
REPO="easyworld/hekate" FILE_PATTERN="_sc.*[.]zip$" END_KEY="zip"
# ==================================================================
fetch_api; get_version
download_file; check_result; unzip_and_clean

# ==================================================================
APP_NAME="Sys-patch"
REPO="gzk47/sys-patch" FILE_PATTERN="sys-patch.*[.]zip$" END_KEY="zip"
# ==================================================================
fetch_api; get_version
download_file; check_result; unzip_and_clean

rm -rf switch/.overlays

# ------------------------------------------------------------------

cat >> ../description.txt << ENDOFFILE
 
------------------------------------------------------------------
 
Hekate payloads 二次引导软件：
 
ENDOFFILE

# ==================================================================
APP_NAME="Lockpick_RCM"
REPO="impeeza/Lockpick_RCMDecScots" FILE_PATTERN="Lockpick_RCM.*[.]bin$" END_KEY="bin"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./bootloader/payloads

# ==================================================================
APP_NAME="TegraExplorer"
REPO="zdm65477730/TegraExplorer" FILE_PATTERN="TegraExplorer.*[.]bin$" END_KEY="bin"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./bootloader/payloads

# ==================================================================
APP_NAME="CommonProblemResolver"
REPO="zdm65477730/CommonProblemResolver" FILE_PATTERN="CommonProblemResolver.*[.]bin$" END_KEY="bin"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./bootloader/payloads

# ------------------------------------------------------------------

cat >> ../description.txt << ENDOFFILE
 
------------------------------------------------------------------
 
相册nro软件：
 
ENDOFFILE

# ==================================================================
APP_NAME="Switch_90DNS_tester" NRO_DIR_NAME="S90NS"
REPO="meganukebmp/Switch_90DNS_tester" FILE_PATTERN="Switch_90DNS_tester.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/S90NS

# ==================================================================
APP_NAME="DBI" NRO_DIR_NAME="DBI"
REPO="rashevskyv/dbi" FILE_PATTERN="DBI.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/DBI

# ==================================================================
APP_NAME="dbi" NRO_DIR_NAME="DBI"
REPO="rashevskyv/dbi" FILE_PATTERN="dbi.*[.]config$" END_KEY="config"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/DBI

# ==================================================================
APP_NAME="Awoo-Installer" 
REPO="Huntereb/Awoo-Installer" FILE_PATTERN="Awoo-Installer.*[.]zip$" END_KEY="zip"
# ==================================================================
fetch_api; get_version
download_file; check_result; unzip_and_clean

# ==================================================================
APP_NAME="HekateToolbox"
REPO="gzk47/Hekate-Toolbox" FILE_PATTERN="HekateToolbox.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/HekateToolbox

# ==================================================================
APP_NAME="NX-Activity-Log"
REPO="zdm65477730/NX-Activity-Log" FILE_PATTERN="NX-Activity-Log.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/NX-Activity-Log

# ==================================================================
APP_NAME="NXThemesInstaller" NRO_DIR_NAME="NXThemesInstaller"
REPO="exelix11/SwitchThemeInjector" FILE_PATTERN="NXThemesInstaller.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/NXThemesInstaller

# ==================================================================
APP_NAME="JKSV" NRO_DIR_NAME="JKSV"
REPO="J-D-K/JKSV" FILE_PATTERN="JKSV.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/JKSV

# ==================================================================
APP_NAME="Tencent-switcher-gui"
REPO="gzk47/Tencent-switcher-GUI" FILE_PATTERN="tencent-switcher-gui.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/Tencent-switcher-gui

# ==================================================================
APP_NAME="Aio-switch-updater"
REPO="HamletDuFromage/aio-switch-updater" FILE_PATTERN="aio-switch-updater.*[.]zip$" END_KEY="zip"
# ==================================================================
fetch_api; get_version
download_file; check_result; unzip_and_clean

# ==================================================================
APP_NAME="wiliwili" NRO_DIR_NAME="wiliwili"
REPO="xfangfang/wiliwili" FILE_PATTERN="wiliwili-NintendoSwitch.*[.]zip$" END_KEY="zip"
# ==================================================================
fetch_api; get_version
download_file; check_result; unzip_and_clean

# ==================================================================
APP_NAME="SimpleModDownloader" NRO_DIR_NAME="SimpleModDownloader"
REPO="PoloNX/SimpleModDownloader" FILE_PATTERN="SimpleModDownloader.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/SimpleModDownloader

# ==================================================================
APP_NAME="Switchfin" NRO_DIR_NAME="Switchfin"
REPO="dragonflylee/Switchfin" FILE_PATTERN="Switchfin.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/Switchfin

# ==================================================================
APP_NAME="Moonlight-Switch" NRO_DIR_NAME="Moonlight-Switch"
REPO="XITRIX/Moonlight-Switch" FILE_PATTERN="Moonlight-Switch.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/Moonlight-Switch

# ==================================================================
APP_NAME="appstore" NRO_DIR_NAME="appstore"
REPO="fortheusers/hb-appstore" FILE_PATTERN="appstore.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/appstore

# ==================================================================
APP_NAME="ReverseNX-Tool"
REPO="gzk47/ReverseNX-Tool" FILE_PATTERN="ReverseNX-Tool.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/ReverseNX-Tool

# ==================================================================
APP_NAME="Goldleaf" NRO_DIR_NAME="Goldleaf"
REPO="XorTroll/Goldleaf" FILE_PATTERN="Goldleaf.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/Goldleaf

# ==================================================================
APP_NAME="Safe_Reboot_Shutdown" NRO_DIR_NAME="Safe_Reboot_Shutdown"
REPO="gzk47/Safe_Reboot_Shutdown" FILE_PATTERN="Safe_Reboot_Shutdown.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/Safe_Reboot_Shutdown

# ==================================================================
APP_NAME="Haku33" NRO_DIR_NAME="Haku33"
REPO="StarDustCFW/Haku33" FILE_PATTERN="Haku33.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/Haku33

# ==================================================================
APP_NAME="linkalho" NRO_DIR_NAME="linkalho"
REPO="impeeza/linkalho" FILE_PATTERN="linkalho.*[.]zip$" END_KEY="zip"
# ==================================================================
fetch_api; get_version
download_file; check_result; unzip_and_clean

# ==================================================================
APP_NAME="Checkpoint" NRO_DIR_NAME="Checkpoint"
REPO="BernardoGiordano/Checkpoint" FILE_PATTERN="Checkpoint.*[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/Checkpoint

# ==================================================================
APP_NAME="ftpd" NRO_DIR_NAME="ftpd"
REPO="mtheall/ftpd" FILE_PATTERN="ftpd[.]nro$" END_KEY="nro"
# ==================================================================
fetch_api; get_version
download_file; check_result; move_to_dir ./switch/ftpd

# ==================================================================
APP_NAME="nxdumptool"
REPO="DarkMatterCore/nxdumptool" FILE_PATTERN="nxdt_rw_poc.*[.]nro$" END_KEY="nro"
# ==================================================================
#API_URL="https://github.com/${REPO}/releases/download/rewrite-prerelease/${FILE_PATTERN}.${END_KEY}"
#curl -sL "${API_URL}" -o "${APP_NAME}.${END_KEY}"
echo "nxdumptool-rewrite latest" >> ../description.txt

# ==================================================================
APP_NAME="sphaira"
REPO="ITotalJustice/sphaira" FILE_PATTERN="sphaira[.]zip$" END_KEY="zip"
# ==================================================================
fetch_api; get_version
download_file; check_result; unzip_and_clean

# ==================================================================
APP_NAME="hbmenu"
REPO="switchbrew/nx-hbmenu" FILE_PATTERN="nx-hbmenu.*[.]zip$" END_KEY="zip"
# ==================================================================
fetch_api; get_version
download_file; check_result; unzip_and_clean

mkdir -p ./switch
mv hbmenu.nro ./switch

# ==================================================================
APP_NAME="hbl"
REPO="switchbrew/nx-hbloader" FILE_PATTERN="hbl.*[.]nsp$" END_KEY="nsp"
# ==================================================================
fetch_api; get_version
download_file; check_result

mv "${APP_NAME}.${END_KEY}" ./atmosphere

# ------------------------------------------------------------------

cat >> ../description.txt << ENDOFFILE

------------------------------------------------------------------
ENDOFFILE

# ------------------------------------------------------------------
# Copy config files from resource directory
# ------------------------------------------------------------------
cp ../resource/exosphere.ini ./exosphere.ini
cp ../resource/boot.ini ./boot.ini
cp ../resource/bootloader/hekate_ipl.ini ./bootloader/hekate_ipl.ini
cp ../resource/bootloader/ini/more.ini ./bootloader/ini/more.ini
cp ../resource/atmosphere/hosts/default.txt ./atmosphere/hosts/default.txt
cp ../resource/atmosphere/hosts/emummc.txt ./atmosphere/hosts/emummc.txt
cp ../resource/atmosphere/hosts/sysmmc.txt ./atmosphere/hosts/sysmmc.txt
cp ../resource/atmosphere/config/override_config.ini ./atmosphere/config/override_config.ini
cp ../resource/atmosphere/config/stratosphere.ini ./atmosphere/config/stratosphere.ini
cp ../resource/atmosphere/config/system_settings.ini ./atmosphere/config/system_settings.ini
cp ../resource/config/JKSV/webdav.json ./config/JKSV/webdav.json
cp ../resource/config/sphaira/config.ini ./config/sphaira/config.ini

if [ $? -ne 0 ]; then
    echo "Copying config files from resource \033[31m❌\033[0m"
else
    echo "Copying config files from resource \033[32m✅\033[0m"
fi