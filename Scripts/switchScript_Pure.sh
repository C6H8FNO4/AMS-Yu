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
    if [ -f "${RESOURCE_DIR}/${SOURCE_DIR}/${APP_NAME}.${END_KEY}" ]; then
        cp "${RESOURCE_DIR}/${SOURCE_DIR}/${APP_NAME}.${END_KEY}" "${APP_NAME}.${END_KEY}"
        echo "${APP_NAME} \033[32m✅ (from resource)\033[0m"
    else
        echo "${APP_NAME} \033[31m❌ 文件不存在: ${RESOURCE_DIR}/${SOURCE_DIR}/${APP_NAME}.${END_KEY}\033[0m"
        return 1
    fi
}

# ------------------------------------------------------------------
# 路径配置（类似环境变量）
# ------------------------------------------------------------------

# 源文件目录（相对仓库根目录）
RESOURCE_DIR="resource"
# 构建输出目录
WORK_DIR="AMS-Pure"
# 描述文件（相对仓库根目录）
DESCRIPTION_FILE="description.txt"

# 构建输出子目录（相对 WORK_DIR）
ATMOSPHERE_DIR="atmosphere"
BOOTLOADER_DIR="bootloader"
PAYLOAD_DIR="bootloader/payloads"
SWITCH_DIR="switch"
CONFIG_DIR="config"

# ------------------------------------------------------------------
# Working Directory Initialization
# ------------------------------------------------------------------

if [ -d "${WORK_DIR}" ]; then
  rm -rf "${WORK_DIR}"
fi
if [ -e "${DESCRIPTION_FILE}" ]; then
  rm -rf "${DESCRIPTION_FILE}"
fi
mkdir -p "${WORK_DIR}"
mkdir -p "${WORK_DIR}/${ATMOSPHERE_DIR}/config"
mkdir -p "${WORK_DIR}/${ATMOSPHERE_DIR}/hosts"
mkdir -p "${WORK_DIR}/${BOOTLOADER_DIR}/ini"
mkdir -p "${WORK_DIR}/${CONFIG_DIR}/JKSV"
mkdir -p "${WORK_DIR}/${CONFIG_DIR}/sphaira"
#mkdir -p "${WORK_DIR}/emuiibo/overlay"

cd "${WORK_DIR}"

# cd 后，源文件目录与描述文件相对 WORK_DIR 的路径
RESOURCE_DIR="../resource"
DESCRIPTION_FILE="../description.txt"

# ------------------------------------------------------------------


cat >> "${DESCRIPTION_FILE}" << ENDOFFILE
大气层核心套件：
 
ENDOFFILE

# ==================================================================
APP_NAME="Atmosphere" END_KEY="zip"
# ==================================================================
copy_from_resource "base" && unzip_and_clean || true

# ==================================================================
APP_NAME="fusee" END_KEY="bin"
# ==================================================================
copy_from_resource "base" && move_to_dir "${PAYLOAD_DIR}" || true

# ==================================================================
APP_NAME="Hekate" END_KEY="zip"
# ==================================================================
copy_from_resource "base" && unzip_and_clean || true

# ==================================================================
APP_NAME="Sys-patch" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean || true

rm -rf "${SWITCH_DIR}/.overlays"

# ------------------------------------------------------------------

cat >> "${DESCRIPTION_FILE}" << ENDOFFILE
 
------------------------------------------------------------------
 
Hekate payloads 二次引导软件：
 
ENDOFFILE

# ==================================================================
APP_NAME="Lockpick_RCM" END_KEY="bin"
# ==================================================================
copy_from_resource "Payloads" && move_to_dir "${PAYLOAD_DIR}" || true

# ==================================================================
APP_NAME="TegraExplorer" END_KEY="bin"
# ==================================================================
copy_from_resource "Payloads" && move_to_dir "${PAYLOAD_DIR}" || true

# ==================================================================
APP_NAME="CommonProblemResolver" END_KEY="bin"
# ==================================================================
copy_from_resource "Payloads" && move_to_dir "${PAYLOAD_DIR}" || true

# ------------------------------------------------------------------

cat >> "${DESCRIPTION_FILE}" << ENDOFFILE
 
------------------------------------------------------------------
 
相册nro软件：
 
ENDOFFILE

# ==================================================================
APP_NAME="Switch_90DNS_tester" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/S90NS" || true

# ==================================================================
APP_NAME="DBI" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/DBI" || true

# ==================================================================
APP_NAME="dbi" END_KEY="config"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/DBI" || true

# ==================================================================
APP_NAME="Awoo-Installer" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean || true

# ==================================================================
APP_NAME="HekateToolbox" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/HekateToolbox" || true

# ==================================================================
APP_NAME="NX-Activity-Log" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/NX-Activity-Log" || true

# ==================================================================
APP_NAME="NXThemesInstaller" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/NXThemesInstaller" || true

# ==================================================================
APP_NAME="JKSV" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/JKSV" || true

# ==================================================================
APP_NAME="Tencent-switcher-gui" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/Tencent-switcher-gui" || true

# ==================================================================
APP_NAME="Aio-switch-updater" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean || true

# ==================================================================
APP_NAME="SimpleModDownloader" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/SimpleModDownloader" || true

# ==================================================================
APP_NAME="Switchfin" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/Switchfin" || true

# ==================================================================
APP_NAME="Moonlight-Switch" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/Moonlight-Switch" || true

# ==================================================================
APP_NAME="appstore" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/appstore" || true

# ==================================================================
APP_NAME="ReverseNX-Tool" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/ReverseNX-Tool" || true

# ==================================================================
APP_NAME="Goldleaf" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/Goldleaf" || true

# ==================================================================
APP_NAME="Safe_Reboot_Shutdown" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/Safe_Reboot_Shutdown" || true

# ==================================================================
APP_NAME="Haku33" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/Haku33" || true

# ==================================================================
APP_NAME="linkalho" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean || true

# ==================================================================
APP_NAME="Checkpoint" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/Checkpoint" || true

# ==================================================================
APP_NAME="ftpd" END_KEY="nro"
# ==================================================================
copy_from_resource "apps" && move_to_dir "${SWITCH_DIR}/ftpd" || true

# ==================================================================
APP_NAME="nxdumptool"
# ==================================================================
echo "nxdumptool-rewrite latest" >> "${DESCRIPTION_FILE}"

# ==================================================================
APP_NAME="sphaira" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean || true

# ==================================================================
APP_NAME="hbl" END_KEY="nsp"
# ==================================================================
copy_from_resource "apps" && mv "${APP_NAME}.${END_KEY}" "${ATMOSPHERE_DIR}" || true

# ------------------------------------------------------------------
# special download: 特殊软件，解压到特定位置
# ------------------------------------------------------------------

# wiliwili: 解压到 switch/ 文件夹
# ==================================================================
APP_NAME="wiliwili" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean && mkdir -p "${SWITCH_DIR}" && mv wiliwili "${SWITCH_DIR}" || true

# hbmenu: 解压到根目录
# ==================================================================
APP_NAME="hbmenu" END_KEY="zip"
# ==================================================================
copy_from_resource "apps" && unzip_and_clean || true

# ------------------------------------------------------------------

cat >> "${DESCRIPTION_FILE}" << ENDOFFILE

------------------------------------------------------------------
ENDOFFILE

# ------------------------------------------------------------------
# Copy config files from resource directory
# ------------------------------------------------------------------
cp "${RESOURCE_DIR}/config_default/exosphere.ini" exosphere.ini
cp "${RESOURCE_DIR}/config_default/boot.ini" boot.ini
cp "${RESOURCE_DIR}/config_default/bootloader/hekate_ipl.ini" "${BOOTLOADER_DIR}/hekate_ipl.ini"
cp "${RESOURCE_DIR}/config_default/bootloader/ini/more.ini" "${BOOTLOADER_DIR}/ini/more.ini"
cp "${RESOURCE_DIR}/config_default/atmosphere/hosts/default.txt" "${ATMOSPHERE_DIR}/hosts/default.txt"
cp "${RESOURCE_DIR}/config_default/atmosphere/hosts/emummc.txt" "${ATMOSPHERE_DIR}/hosts/emummc.txt"
cp "${RESOURCE_DIR}/config_default/atmosphere/hosts/sysmmc.txt" "${ATMOSPHERE_DIR}/hosts/sysmmc.txt"
cp "${RESOURCE_DIR}/config_default/atmosphere/config/override_config.ini" "${ATMOSPHERE_DIR}/config/override_config.ini"
cp "${RESOURCE_DIR}/config_default/atmosphere/config/stratosphere.ini" "${ATMOSPHERE_DIR}/config/stratosphere.ini"
cp "${RESOURCE_DIR}/config_default/atmosphere/config/system_settings.ini" "${ATMOSPHERE_DIR}/config/system_settings.ini"
cp "${RESOURCE_DIR}/config_default/config/JKSV/webdav.json" "${CONFIG_DIR}/JKSV/webdav.json"
cp "${RESOURCE_DIR}/config_default/config/sphaira/config.ini" "${CONFIG_DIR}/sphaira/config.ini"

if [ $? -ne 0 ]; then
    echo "Copying config files from resource \033[31m❌\033[0m"
else
    echo "Copying config files from resource \033[32m✅\033[0m"
fi