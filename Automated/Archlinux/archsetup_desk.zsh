#!/bin/zsh

#
# Colors
#

# Bash color escape sequences
RESET='\033[0;0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
echo "Test:Echo:bash-colors${GREEN}GREEN${RED}RED${RESET}"

# Zsh sets colors differently than Bash
print -P "Test:Print:zsh-colors:%F{red}RED%F{green}GREEN%F{yellow}YELLOW%F{blue}BLUE%F{magenta}MAGENTA%F{cyan}CYAN%F{white}WHITE%f"
print

#
# Script debug options
#
set -e # exit when any command fails
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "\"${last_command}\" command failed with exit code $?."' EXIT

#setopt verbose # verbose
#set -x # echo on (post parsing)
#set +x # echo off (post parsing)
#set -v # echo on
#set +v # echo off


#
# Setup
#
function ArchlinuxSetup_EnvZshTmuxNetwork () {
echo "${GREEN} # Archlinux Setup Desktop 2022-10 ${RESET}"

## No Network No Life
# run  dhcp
dhcpcd 
export https_proxy=http://..
# check connection 
ip a 

## Set hostname
pacman -S hostnamectl
hostnamectl set-hostname Pwandzil-Dev --static

# Tmux no Cry
#Problem1: tmuxcopy does not work - simply because it runs in EMACS mode by def *_-

#
# Environment variables - essentials
#
# https://wiki.archlinux.org/title/environment_variables
#The following files can be used for defining global environment variables on your system, each with different limitations:
* /etc/environment is used by the pam_env module and is shell agnostic so scripting or glob expansion cannot be used. The file only accepts variable=value pairs.
* /etc/profile initializes variables for login shells only. It does, however, run scripts and can be used by all Bourne shell compatible shells.
* Shell specific configuration files - Global configuration files of your shell, initializes variables and runs scripts. For example Bash#Configuration files or Zsh#Startup/Shutdown files.
# Proxy
If the proxy environment variables are to be made available to all users and all applications, the above mentioned export commands may be added to a script, say proxy.sh inside /etc/profile.d/.
 # TMUX 
# https://wiki.archlinux.org/title/Tmux#Configuration
# emacs mode us default, set VISUAL or EDITOR contains ‘vi’

echo EDITOR=vim >> /etc/environment 
echo VISUAL=vim >> /etc/environment 
echo HTTP_PROXY=https:// 

echo now login and logout!

# Networking services
# https://wiki.archlinux.org/title/Systemd-networkd
# Create configurations for wired with DHCP
/etc/systemd/networks

# NOTE! For legacy networks set DHCP identifier to Mac
[Match]
Name=<interfacename>
[Network]
DHCP=yes
[DHCP]
ClientIdentifier=mac


# start service https://wiki.archlinux.org/title/Systemd#Using_units 
systemctl start systemd-networkd.service
# enable service at startup for all users
systemctl enable systemd-networkd.service

echo now login and logout!

#12.3Alternative shells
https://wiki.archlinux.org/title/zsh#Making_Zsh_your_default_shell
https://wiki.archlinux.org/title/Command-line_shell#Changing_your_default_shell
chsh -s /bin/zsh
ps -p $$ 

# Oh My Z-shell
# https://github.com/ohmyzsh/ohmyzsh

# Enable ZSH History 
# https://unix.stackexchange.com/questions/389881/history-isnt-preserved-in-zsh


# Browser
# ncourses browser
pacman -S w3m

# wget with password and user

}
function ArchlinuxSetup_2 () {
echo "${GREEN} # General Recommendations Postinstall 2022-10 ${RESET}"
# https://wiki.archlinux.org/title/General_recommendations

#1.System administration 
#1.1User account
# https://wiki.archlinux.org/title/Users_and_groups
# https://wiki.archlinux.org/title/Systemd-homed
# Ripoff launchd from MacOs (demon manager)
# opensource.apple.com : SWITFT : KUBERNETES : WEBKIT

#CreateUser 
systemctl enable systemd-homed.service 
systemctl start  systemd-homed.service 
homectl create username --shell=/usr/bin/zsh
}

function ArchlinuxSetup_3 () {
echo "${GREEN} # Archlinux Setup Desktop 2022-10 ${RESET}"
}
function ArchlinuxSetup_4 () {
echo "${GREEN} # Archlinux Setup Desktop 2022-10 ${RESET}"
}
function ArchlinuxSetup_5 () {
echo "${GREEN} # Archlinux Setup Desktop 2022-10 ${RESET}"
}
function ArchlinuxSetup_6 () {
echo "${GREEN} # Archlinux Setup Desktop 2022-10 ${RESET}"
}
function ArchlinuxSetup_7 () {
echo "${GREEN} # Archlinux Setup Desktop 2022-10 ${RESET}"
}


#
# Main
#
printf "Select the part to run [Y/n]
         1. ArchlinuxSetup_EnvZshTmuxNetwork
         2. ArchlinuxSetup_2
         3. ArchlinuxSetup_3
         4. ArchlinuxSetup_4
         5. ArchlinuxSetup_5
         6. ArchlinuxSetup_6
	 \n"
read answer
case $answer in
  1) ArchlinuxSetup_EnvZshTmuxNetwork
  ;;
  2) ArchlinuxSetup_2
  ;;
  3) ArchlinuxSetup_3
  ;;
  4) ArchlinuxSetup_4
  ;;
  5) ArchlinuxSetup_5
  ;;
  6) ArchlinuxSetup_6
  ;;
  7) ArchlinuxSetup_7
  ;;
esac


