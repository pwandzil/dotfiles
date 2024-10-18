# Basic Commands if your ever find everything is different and even you are stranger to yourself


~~~sh
# enter the void *** clear screen
#Ctrl+L
clear -x

# stretch
sudo pacman -S lolcat
cmatrix | lolcat

# look around
ps
ps -a
ps -ax
ps aux
pkill telnet

# walk
cd #without additional argument goes to the homedir

# identity
su      #superuser keep env
su -    #superuser new env and goto userhome
sudo su #superuser via sudo and user password only
#Ctrl-D/exit #go back
passwd #change password

# change
chown pwandzil:developers file.txt
chmod 764 file.txt # owner 7(rwx), group 6(rw-), public 4 (r--)
chmod g+x file.sh  # group+execute
chgrp developers file.txt

# copy paste
#Shift+mouse_select  # select on VT terminal host side
#Shift+insert        # paste
#Shift+Ctrl+V        # paste

# reload last life
tmux attach

# if not possible start over from scratch
Setfont
Dhcpcd
Ip a
#/etc/systemd/network/10-eth0.network
ClientIdentifier=mac
Systemctl restart systemd-network
Export https_proxy=..

# using find is straightforward
find /path -name "example.txt"
find ./ -type f -name "*.txt" -exec grep 'Geek'  {} \;
# find files from last 7 lives
find /path/to/search -mtime -7

# SCP from local windows client to remote linux
$ C:\Users\<username>> scp C:\Users\<username>\Downloads\linux-pki-2022-09-21-2615b26.tar.xz <username>@<ip_address>:/home/user/...

# SCP from remote linux to local windows client
$ scp -r <username>@><hostname>:/srv/share/bin C:\Users\<username>\Downloads\

# Run
# Mergetool / Vimdiff / Neovim diff
nvim -d file1 file2

# vim
vim -u NONE      # skip loading configuration 
~~~
