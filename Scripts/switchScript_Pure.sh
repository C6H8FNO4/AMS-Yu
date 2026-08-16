#!/bin/sh

set -e

# ------------------------------------------------------------------
# Common Functions
# ------------------------------------------------------------------

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

# Copy file from resource dir; skip with error if missing
# Usage: copy_from_resource "SOURCE_DIR"
copy_from_resource() {
    SOURCE_DIR="$1"
    if [ -f "../resource/${SOURCE_DIR}/${APP_NAME}.${END_KEY}" ]; then
        cp "../resource/${SOURCE_DIR}/${APP_NAME}.${END_KEY}" "${APP_NAME}.${END_KEY}"
        echo "${APP_NAME} \033[32m✅ (from resource)\033[0m"
    else
        echo "${APP_NAME} \033[31m❌ 文件不存在: resource/${SOURCE_DIR}/${APP_NAME}.${END_KEY}\033[0m"
        return 1
    fi
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
APP_NAME="Atmosphere" END_KEY="zip"
# ==================================================================
copy_from_resource "Atmosphere" && unzip_and_clean || true

# ==================================================================
APP_NAME="fusee" END_KEY="bin"
# ==================================================================
copy_from_resource "Payloads" && move_to_dir ./bootloader/payloads || true

# ==================================================================
APP_NAME="Hekate" END_KEY="zip"
# ==================================================================
copy_from_resource "hekate" && unzip_and_clean || true

# ==================================================================
APP_NAME="Sys-patch" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean || true

rm -rf switch/.overlays

# ------------------------------------------------------------------

cat >> ../description.txt << ENDOFFILE
 
------------------------------------------------------------------
 
Hekate payloads 二次引导软件：
 
ENDOFFILE

# ==================================================================
APP_NAME="Lockpick_RCM" END_KEY="bin"
# ==================================================================
copy_from_resource "Payloads" && move_to_dir ./bootloader/payloads || true

# ==================================================================
APP_NAME="TegraExplorer" END_KEY="bin"
# ==================================================================
copy_from_resource "Payloads" && move_to_dir ./bootloader/payloads || true

# ==================================================================
APP_NAME="CommonProblemResolver" END_KEY="bin"
# ==================================================================
copy_from_resource "Payloads" && move_to_dir ./bootloader/payloads || true

# ------------------------------------------------------------------

cat >> ../description.txt << ENDOFFILE
 
------------------------------------------------------------------
 
相册nro软件：
 
ENDOFFILE

# ==================================================================
APP_NAME="Switch_90DNS_tester" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/S90NS || true

# ==================================================================
APP_NAME="DBI" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/DBI || true

# ==================================================================
APP_NAME="dbi" END_KEY="config"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/DBI || true

# ==================================================================
APP_NAME="Awoo-Installer" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean || true

# ==================================================================
APP_NAME="HekateToolbox" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/HekateToolbox || true

# ==================================================================
APP_NAME="NX-Activity-Log" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/NX-Activity-Log || true

# ==================================================================
APP_NAME="NXThemesInstaller" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/NXThemesInstaller || true

# ==================================================================
APP_NAME="JKSV" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/JKSV || true

# ==================================================================
APP_NAME="Tencent-switcher-gui" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/Tencent-switcher-gui || true

# ==================================================================
APP_NAME="Aio-switch-updater" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean || true

# ==================================================================
APP_NAME="wiliwili" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean || true

# ==================================================================
APP_NAME="SimpleModDownloader" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/SimpleModDownloader || true

# ==================================================================
APP_NAME="Switchfin" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/Switchfin || true

# ==================================================================
APP_NAME="Moonlight-Switch" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/Moonlight-Switch || true

# ==================================================================
APP_NAME="appstore" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/appstore || true

# ==================================================================
APP_NAME="ReverseNX-Tool" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/ReverseNX-Tool || true

# ==================================================================
APP_NAME="Goldleaf" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/Goldleaf || true

# ==================================================================
APP_NAME="Safe_Reboot_Shutdown" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/Safe_Reboot_Shutdown || true

# ==================================================================
APP_NAME="Haku33" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/Haku33 || true

# ==================================================================
APP_NAME="linkalho" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean || true

# ==================================================================
APP_NAME="Checkpoint" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/Checkpoint || true

# ==================================================================
APP_NAME="ftpd" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir ./switch/ftpd || true

# ==================================================================
APP_NAME="nxdumptool"
# ==================================================================
echo "nxdumptool-rewrite latest" >> ../description.txt

# ==================================================================
APP_NAME="sphaira" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean || true

# ==================================================================
APP_NAME="hbmenu" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean && mkdir -p ./switch && mv hbmenu.nro ./switch || true

# ==================================================================
APP_NAME="hbl" END_KEY="nsp"
# ==================================================================
copy_from_resource "apps" && mv "${APP_NAME}.${END_KEY}" ./atmosphere || true

# ------------------------------------------------------------------

cat >> ../description.txt << ENDOFFILE

------------------------------------------------------------------
ENDOFFILE

# ------------------------------------------------------------------
# Copy config files from resource directory
# ------------------------------------------------------------------
cp ../resource/config_default/exosphere.ini ./exosphere.ini
cp ../resource/config_default/boot.ini ./boot.ini
cp ../resource/config_default/bootloader/hekate_ipl.ini ./bootloader/hekate_ipl.ini
cp ../resource/config_default/bootloader/ini/more.ini ./bootloader/ini/more.ini
cp ../resource/config_default/atmosphere/hosts/default.txt ./atmosphere/hosts/default.txt
cp ../resource/config_default/atmosphere/hosts/emummc.txt ./atmosphere/hosts/emummc.txt
cp ../resource/config_default/atmosphere/hosts/sysmmc.txt ./atmosphere/hosts/sysmmc.txt
cp ../resource/config_default/atmosphere/config/override_config.ini ./atmosphere/config/override_config.ini
cp ../resource/config_default/atmosphere/config/stratosphere.ini ./atmosphere/config/stratosphere.ini
cp ../resource/config_default/atmosphere/config/system_settings.ini ./atmosphere/config/system_settings.ini
cp ../resource/config_default/config/JKSV/webdav.json ./config/JKSV/webdav.json
cp ../resource/config_default/config/sphaira/config.ini ./config/sphaira/config.ini

if [ $? -ne 0 ]; then
    echo "Copying config files from resource \033[31m❌\033[0m"
else
    echo "Copying config files from resource \033[32m✅\033[0m"
fi