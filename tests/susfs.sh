#!/bin/bash

FILE=$1

[ -f "$FILE" ] || {
	echo "Provide a config file as argument"
	exit 1
}

CONFIGS_ON="
CONFIG_KSU_SUSFS=y
CONFIG_KSU_SUSFS_SUS_PATH=y
CONFIG_KSU_SUSFS_SUS_KSTAT=y
CONFIG_KSU_SUSFS_SUS_OVERLAYFS=y
CONFIG_KSU_SUSFS_AUTO_ADD_SUS_BIND_MOUNT=y
CONFIG_KSU_SUSFS_AUTO_ADD_TRY_UMOUNT_FOR_BIND_MOUNT=y
CONFIG_KSU_SUSFS_AUTO_ADD_SUS_KSU_DEFAULT_MOUNT=y
CONFIG_KSU_SUSFS_TRY_UMOUNT=y
CONFIG_KSU_SUSFS_SPOOF_CMDLINE_OR_BOOTCONFIG=y
CONFIG_KSU_SUSFS_SPOOF_UNAME=y
CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS=y
CONFIG_KSU_SUSFS_HAS_MAGIC_MOUNT=y
"
append_config() {
    local config="$1"
    if ! grep -q "^${config}" "$FILE"; then
        echo "Adding: $config"
        echo "$config" >> "$FILE"
    else
        echo "Already exists: $config"
    fi
}

echo "Checking and appending configurations to $FILE..."

while IFS= read -r config; do
    [ -n "$config" ] && append_config "$config"
done <<< "$CONFIGS_ON"

if grep -q "CONFIG_KPROBES=y" "$FILE"; then
    append_config "CONFIG_KSU_SUSFS_SUS_SU=y"
else
    append_config "CONFIG_KSU_SUSFS_SUS_SU=n"
fi

echo "Done: Configuration file has been updated."
