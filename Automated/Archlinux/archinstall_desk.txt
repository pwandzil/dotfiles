#!/bin/zsh

#
# Colors
#

# Bash color escape sequences
RESET='\033[0;0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
echo "Echo:bash-colors${GREEN}GREEN${RED}RED${RESET}"

# Zsh sets colors differently than Bash
print -P "Print:zsh-colors:%F{red}RED%F{green}GREEN%F{yellow}YELLOW%F{blue}BLUE%F{magenta}MAGENTA%F{cyan}CYAN%F{white}WHITE%f"
print

#
# Script debug options
#
set -e # exit when any command fails
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "\"${last_command}\" command failed with exit code $?."' EXIT

#setopt verbose # verbose
set -x # echo on (post parsing)
set +x # echo off (post parsing)
#set -v # echo on


#
# Installation
#
echo "${GREEN} # Archlinux Install Desktop 2022-07 ${RESET}"

echo "${GREEN} # 1.4 Boot the live environment ${RESET}"
echo "${GREEN} # 1.5 Keboard layout: set to Poland pl2 ${RESET}"
 # root@archiso ~ # ls /usr/share/kbd/keymaps/**/*.map.gz
loadkeys pl2

echo "${GREEN} # Verify bootmode UEFI[OK]/BIOS ${RESET}"
if ls /sys/firmware/efi/efivars | grep BootOrder; then
	echo "Running: UEFI"
else
	echo "Running: Legacy BIOS"
fi

echo "${GREEN} # Connect to the internet (mind the proxy!) ${RESET}"
 # root@archiso ~ # ip link
 # 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
 # 2: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
 # 3: eno1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN mode DEFAULT group default qlen 1000

ip link | grep "state UP"

# Set the proxy if needed
# Check internet connection with
curl -I https://archlinux.org | grep 200

echo "${GREEN} # Update system clock ${RESET}"
timedatectl set-ntp true

# Partition
echo "${GREEN} # Partition the disk  ${RESET}"
printf "Do you wish to partition sda1 to UEFI/GPT efi/swap/root/home? [Y/n]"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
	echo Yes
	print -P "%F{red}Create new GPT partition table%f"
	echo 'label: gpt' | sfdisk /dev/sda
	# sfdisk -T --label=gpt | grep x86-64
	# C12A7328-F81F-11D2-BA4B-00A0C93EC93B  EFI System
	# 0657FD6D-A4AB-43C4-84E5-0933C84B4F4F  Linux swap
	# 4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709  Linux root (x86-64)
	# 933AC7E1-2EB4-4F13-B844-0E14E2AEF915  Linux home

	echo -e \
	"size=512M, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B\n"\
	"size=32G,  type=0657FD6D-A4AB-43C4-84E5-0933C84B4F4F\n"\
	"size=100G, type=4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709\n"\
	"size=+,    type=933AC7E1-2EB4-4F13-B844-0E14E2AEF915\n" | sfdisk /dev/sda
else
	echo No.
fi

printf "Do you wish to partition sda1 to UEFI/GPT efi/swap/linux_filesystem(btrfs)? [Y/n]"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
	echo Yes
	print -P "%F{red}Create new GPT partition table%f"
	echo 'label: gpt' | sfdisk /dev/sda
	# sfdisk -T --label=gpt | grep x86-64
	# C12A7328-F81F-11D2-BA4B-00A0C93EC93B  EFI System
	# 0657FD6D-A4AB-43C4-84E5-0933C84B4F4F  Linux swap
	# 0FC63DAF-8483-4772-8E79-3D69D8477DE4  Linux filesystem

	echo -e \
	"size=512M, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B\n"\
	"size=16G,  type=0657FD6D-A4AB-43C4-84E5-0933C84B4F4F\n"\
	"size=+,    type=0FC63DAF-8483-4772-8E79-3D69D8477DE4\n" | sfdisk /dev/sda
	mkfs.btrfs -L RootPart0 /dev/sda3
else
	echo No.
fi

print -P "%F{cyan}Print partition table%f"


fdisk -l | grep dev
# lsblk with information about filesysems
lsblk -f
echo THEEND


set +v # echo off
