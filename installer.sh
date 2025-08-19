#!/bin/bash
# ==============================================
# INSTALLATION SCRIPT FOR RadioRelay PLUGIN
# Command: wget https://raw.githubusercontent.com/angelheart150/RadioRelay/main/installer.sh -O - | /bin/sh #
# ================================================================
# Preparing colors for printing
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'
PACKAGE_DIR="RadioRelay/main"
MY_MAIN_URL="https://raw.githubusercontent.com/angelheart150/"
BASE_URL="${MY_MAIN_URL}${PACKAGE_DIR}/"
# ---------------------------
# The internet connection verification function
# ---------------------------
if ! ping -c 1 github.com >/dev/null 2>&1; then
    echo -e "${RED}ERROR: No internet connection!${RESET}"
    exit 1
fi
# ---------------------------
# Python version detection function
# ---------------------------
detect_python_version() {
    if command -v python3 &>/dev/null; then
        PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}' | cut -d'.' -f1-2)
    elif command -v python &>/dev/null; then
        PYTHON_VERSION=$(python --version 2>&1 | awk '{print $2}' | cut -d'.' -f1-2)
    else
        echo -e "${RED}ERROR: Python is not installed in this Image! Please install Python 3.9 or higher.${RESET}"
        exit 1
    fi
    MIN_VERSION="3.9"
    if [[ "$(printf '%s\n' "$MIN_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$MIN_VERSION" ]]; then
        echo -e "${RED}ERROR: Image Python is $PYTHON_VERSION It isn't supported . It can installed on 3.9,3.10,3.11,3.12 and 3.13.${RESET}"
        exit 1
    fi
    echo "$PYTHON_VERSION"
}
# ---------------------------
# Start installation
# ---------------------------
echo -e "${YELLOW}************************************************************${RESET}"
echo -e "${GREEN}**           RadioRelay Plugin Installer STARTED          **${RESET}"
echo -e "${YELLOW}************************************************************${RESET}"
echo -e "${YELLOW}************************************************************${RESET}"
echo -e "${GREEN}**              Developed by: Angel_heart                 **${RESET}"
echo -e "${YELLOW}************************************************************${RESET}"
PY_VER=$(detect_python_version)
# Determine the name of the file based on the Python version
IPK="enigma2-plugin-extensions-radiorelay_1.0.py${PY_VER}_all.ipk"
MY_URL="${BASE_URL}${IPK}"
MY_TMP_FILE="/tmp/${IPK}"

# ---------------------------
# Download and install package
# ---------------------------
echo -e "${GREEN}Running opkg update first...${RESET}"
opkg update

echo -e "${GREEN}Downloading package for Python $PY_VER...${RESET}"
sleep 2
if wget -T 15 -q "$MY_URL" -P "/tmp/"; then
    echo -e "${YELLOW}Installing package...${RESET}"
    sleep 2
    if opkg install --force-reinstall "$MY_TMP_FILE"; then
        echo -e "${GREEN}SUCCESSFULLY INSTALLED${RESET}"
        echo -e "${YELLOW}Restarting enigma2...${RESET}"
        # killall -9 enigma2
    else
        echo -e "${RED}INSTALLATION FAILED after opkg update!${RESET}"
        exit 1
    fi
else
    echo -e "${RED}DOWNLOAD FAILED: $MY_URL${RESET}"
    exit 1
fi
exit 0