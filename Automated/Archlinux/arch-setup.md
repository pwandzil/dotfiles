# Arch Linux Post-Install Setup Guide

> **Author**: Przemysław Wandzilak
> **Last updated**: 2026-04-03
> **License**: Public

---

## Table of Contents

1. [Introduction](#introduction)
2. [Setup](#setup)
   - [2.0 Discovery — Print Current Configuration](#20-discovery--print-current-configuration)
   - [2.1 Network Configuration (DHCP)](#21-network-configuration-dhcp)
   - [2.2 Change Hostname, User and Password](#22-change-hostname-user-and-password)
   - [2.3 Basic Tools — VIM and TMUX](#23-basic-tools--vim-and-tmux)
   - [2.4 Install Developer Tools — Python, UV, VS Code](#24-install-developer-tools--python-uv-vs-code)
3. [Suggestions](#suggestions)
4. [Appendix A — Nano Cheatsheet](#appendix-a--nano-cheatsheet)
5. [Appendix B — TMUX Cheatsheet](#appendix-b--tmux-cheatsheet)
6. [Appendix C — VIM Cheatsheet](#appendix-c--vim-cheatsheet)
7. [Appendix D — VIM Plugins Comparison](#appendix-d--vim-plugins-comparison)
8. [Appendix E — tar/gz Cheatsheet](#appendix-e--targz-cheatsheet)

---

## Introduction

This guide describes how to set up **Arch Linux** as a development workstation after a fresh install. It covers network setup, user management, essential tools (VIM, TMUX), and a developer stack (Python, VS Code).

### Goals

1. **Network** — Configure DHCP with systemd-networkd.
2. **Hostname & identity** — Set hostname, create a user, configure sudo.
3. **Basic tools** — Install and configure VIM and TMUX for productive terminal work.
4. **Developer stack** — Install Python, Python UV, Visual Studio Code, and essential dev packages.

### Quick Reference — Cheatsheets

- **[Appendix A — Nano Cheatsheet](#appendix-a--nano-cheatsheet)** — bare Arch survival editor
- **[Appendix B — TMUX Cheatsheet](#appendix-b--tmux-cheatsheet)** — based on `.tmux.conf`
- **[Appendix C — VIM Cheatsheet](#appendix-c--vim-cheatsheet)** — based on `.vimrc`
- **[Appendix D — VIM Plugins Comparison](#appendix-d--vim-plugins-comparison)** — `.vimrc` (active) vs `.vimrc2` (legacy)

---

## Setup

### 2.0 Discovery — Print Current Configuration

Before making changes, discover the current system state.

**Current shell:**

```bash
# Which shell am I in right now?
echo $0
ps -p $$

# Default shell for current user
echo $SHELL
grep $(whoami) /etc/passwd | cut -d: -f7

# Available shells on the system
cat /etc/shells
```

**Hostname and system info:**

```bash
# Hostname
hostnamectl

# Full system summary
uname -a
cat /etc/os-release
```

**Network and DHCP:**

```bash
# IP addresses and interfaces
ip a

# Active DHCP leases
networkctl status
systemctl status systemd-networkd

# DNS resolver
resolvectl status
cat /etc/resolv.conf
```

**Active users and sessions:**

```bash
# List currently logged-in users
who
w

# List all user accounts on the system
cat /etc/passwd | grep -v nologin | grep -v /bin/false

# Active login sessions (systemd)
loginctl list-sessions
loginctl list-users

# Last logins
last -a | head -20

# Check if systemd-homed is in use
systemctl status systemd-homed.service 2>/dev/null
homectl list 2>/dev/null
```

**Default editor:**

```bash
echo $EDITOR
echo $VISUAL
```

---

### 2.1 Network Configuration (DHCP)

> **Important**: Network must be configured first — `pacman` needs internet access to download any packages (vim, zsh, etc.).

#### DHCP with systemd-networkd

Create a network configuration file (use `nano` — it's available on bare Arch):

```bash
nano /etc/systemd/network/20-wired.network
```

Contents:

```ini
[Match]
Name=<interface_name>

[Network]
DHCP=yes

[DHCP]
# For legacy networks set DHCP identifier to MAC
ClientIdentifier=mac
```

> **Tip**: Find your interface name with `ip link`. Common names: `ens18`, `eth0`, `enp0s3`.

Enable and start the service:

```bash
systemctl enable --now systemd-networkd.service
systemctl enable --now systemd-resolved.service
```

Verify connectivity:

```bash
ping -c 3 archlinux.org
```

#### Update package database and system

> **Note**: On a fresh or old Arch install, mirror packages may be outdated (404 errors).
> Always refresh the keyring first, then do a full system update.

```bash
pacman -Sy archlinux-keyring
pacman -Syu
```

#### Install VIM

Now that the network is up, install `vim` (needed for `visudo` and general editing):

```bash
pacman -S vim
```

#### Celebrate — you have internet!

```bash
pacman -S lolcat cmatrix
cmatrix | lolcat
```

---

### 2.2 Change Hostname, User and Password

#### Set hostname

```bash
# Set the static hostname
hostnamectl set-hostname <your-hostname> --static

# Verify
hostnamectl
```

#### Create a user account

> **Note**: At this stage ZSH is not yet installed — use `/bin/bash` as the default shell.
> You can switch to ZSH later after installing it (see [2.3 Basic Tools](#23-basic-tools--vim-and-tmux)).

Using `systemd-homed` (modern approach):

```bash
systemctl enable --now systemd-homed.service
homectl create <username> \
  --shell=/bin/bash \
  --member-of=wheel \
  --storage=directory
```

> `--storage=directory` uses a plain `/home/<username>` directory (like traditional accounts).
> Without it, `systemd-homed` defaults to LUKS-encrypted home images, which can cause issues
> with services expecting a normal directory structure (e.g. Samba, SSH keys).

After creating the user, activate the home directory:

```bash
homectl activate <username>
```

> **Note**: `homectl activate` is required even with `--storage=directory` — without it, `su - <username>` will fail because the home is not mounted yet. On subsequent boots, logging in will activate it automatically.

Or the traditional way:

```bash
useradd -m -G wheel -s /bin/bash <username>
passwd <username>
```

> **If you forgot the wheel group** (e.g. `homectl create` without `--member-of`):
> ```bash
> # For systemd-homed users:
> homectl update <username> --member-of=wheel
>
> # For traditional users:
> usermod -aG wheel <username>
> ```

Change shell to ZSH later (after `pacman -S zsh`):

```bash
chsh -s /usr/bin/zsh
```

#### Configure sudo

> `visudo` looks for `/usr/bin/vi` by default. Even though `vim` is installed, the current session may not have `EDITOR` set yet. Pass it explicitly:

```bash
EDITOR=vim visudo
# Uncomment: %wheel ALL=(ALL:ALL) ALL
```

#### Switch to the new user

From this point on, work as your regular user — not root. Use `sudo` when elevated privileges are needed.

```bash
# Log in as the new user
su - <username>

# Verify
whoami
id
```

---

### 2.3 Basic Tools — VIM and TMUX

#### Install TMUX and essentials

```bash
sudo pacman -S tmux git wget htop openssh
```

> VIM was already installed in [2.1 Network Configuration](#21-network-configuration-dhcp).

> **Troubleshooting**: If you get `GLIBC_2.xx not found` errors (e.g. `tmux: /usr/lib/libc.so.6: version 'GLIBC_2.42' not found`), it means packages are newer than your base system. Fix with a full upgrade:
> ```bash
> sudo pacman -Syu
> ```
> On Arch, **never install packages without upgrading first** — partial upgrades break library dependencies.
>
> **Troubleshooting `pacman -Syu` nvidia firmware conflicts**:
> If `pacman -Syu` fails with errors like:
> ```
> error: failed to commit transaction (conflicting files)
> linux-firmware-nvidia: /usr/lib/firmware/nvidia/ad103 exists in filesystem
> ```
> Fix by removing and reinstalling:
> ```bash
> sudo pacman -Rdd linux-firmware
> sudo pacman -Syu linux-firmware
> ```
> `pacman -Rdd` removes the package without checking dependencies — use only for this specific fix.

#### Set VIM as default editor

```bash
sudo tee -a /etc/environment << 'EOF'
EDITOR=vim
VISUAL=vim
EOF
```

#### Deploy dotfiles

```bash
# Clone your dotfiles repo
git clone <your-dotfiles-repo-url> ~/dotfiles

# Symlink configurations
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
```

#### Install VIM plugins (vim-plug)

```bash
# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins
vim +PlugInstall +qall
```

#### Install TMUX Plugin Manager

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Start tmux and install plugins
tmux
# Press: Ctrl-a + I  (capital I) to install plugins
```

See **[Appendix B](#appendix-b--tmux-cheatsheet)** and **[Appendix C](#appendix-c--vim-cheatsheet)** for usage cheatsheets.

---

### 2.4 Install Developer Tools — Python, UV, VS Code

#### Install base development packages

```bash
sudo pacman -S base-devel git git-lfs the_silver_searcher ripgrep
```

```bash
sudo pacman -S python python-pip python-setuptools
```

#### Install paru (AUR helper)

Pre-built binary (quick):

```bash
mkdir -p ~/aur && cd ~/aur
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -sri
```

Or build from source:

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

#### Python UV (modern Python package manager)

```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or via pacman/paru if available
paru -S uv

# Verify
uv --version
```

#### Visual Studio Code

```bash
# Install from AUR
paru -S visual-studio-code-bin
```

#### Configure git

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Install git-lfs
git lfs install
```

#### Install Oh My Zsh (optional)

```bash
sudo pacman -S zsh
chsh -s /usr/bin/zsh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

---

## Suggestions

### Podman (Rootless Containers)

```bash
sudo pacman -S podman
podman pull docker.io/ubuntu:22.04
podman run --name=devel -i -t -d -v /storage:/storage:Z,U --userns=keep-id ubuntu:22.04
```

### Shell & Terminal

- **ZSH history** — Ensure history is preserved across sessions. Add to `.zshrc`:
  ```bash
  HISTSIZE=10000
  SAVEHIST=10000
  HISTFILE=~/.zsh_history
  setopt appendhistory
  ```

- **Windows Terminal** — When attaching via Windows Terminal, use `Shift` to select text on the host rather than sending selection to TMUX.

- **w3m** — Install the ncurses-based browser for quick web lookups without a GUI:
  ```bash
  sudo pacman -S w3m
  ```

### VIM Workflow

- Use **vim-plug** (as in current `.vimrc`) rather than Vundle (`.vimrc2`) — it's faster and supports parallel installs.
- Enable **The Silver Searcher** (`ag`) for fast code search — already configured in `.vimrc`.
- Use **ctags** (`F8` for Tagbar) for code navigation in C/C++ projects.

### Security Notes

- Always use `sudo -E` when a command needs proxy environment variables.
- **Harden SSH** — disable root login and password auth:

  ```bash
  sudo vim /etc/ssh/sshd_config
  ```

  Set explicitly (don't rely on commented-out defaults):

  ```
  PermitRootLogin no
  PasswordAuthentication no
  KbdInteractiveAuthentication no
  ```

  Then restart:

  ```bash
  sudo systemctl restart sshd
  ```

  > Use SSH keys for authentication instead of passwords.

---

## Appendix A — Nano Cheatsheet

> `nano` is pre-installed on bare Arch — use it before `vim` is available.
> `^` means `Ctrl`, `M-` means `Alt`.

| Action | Keybinding |
|--------|------------|
| **File** | |
| Save | `Ctrl-O` then `Enter` |
| Exit | `Ctrl-X` |
| Save and exit | `Ctrl-X` then `Y` then `Enter` |
| Discard and exit | `Ctrl-X` then `N` |
| Open file | `Ctrl-R` |
| **Navigation** | |
| Go to line number | `Ctrl-_` (or `Ctrl-/`) |
| Page up | `Ctrl-Y` |
| Page down | `Ctrl-V` |
| Beginning of line | `Home` or `Ctrl-A` |
| End of line | `End` or `Ctrl-E` |
| **Editing** | |
| Cut line | `Ctrl-K` |
| Paste (uncut) | `Ctrl-U` |
| Undo | `Alt-U` |
| Redo | `Alt-E` |
| **Search** | |
| Search | `Ctrl-W` |
| Search next | `Alt-W` |
| Search and replace | `Ctrl-\` |
| **Selection** | |
| Start mark (select) | `Alt-A` then move cursor |
| Copy marked region | `Alt-6` |
| Cut marked region | `Ctrl-K` |

---

## Appendix B — TMUX Cheatsheet

Based on: `.tmux.conf`

> Prefix key: **`Ctrl-a`** (remapped from default `Ctrl-b`)

| Action | Keybinding |
|--------|-----------|
| **Sessions** | |
| Reload config | `tmux source-file ~/.tmux.conf` |
| Detach | `Ctrl-a d` |
| **Windows** | |
| New window | `Ctrl-a c` |
| Next window | `Ctrl-a Ctrl-l` |
| Previous window | `Ctrl-a Ctrl-h` |
| **Panes** | |
| Split horizontal | `Ctrl-a \|` |
| Split vertical | `Ctrl-a -` |
| New pane (auto-layout) | `Alt-n` |
| Kill pane (auto-layout) | `Alt-c` |
| Navigate left | `Ctrl-a h` |
| Navigate down | `Ctrl-a j` |
| Navigate up | `Ctrl-a k` |
| Navigate right | `Ctrl-a l` |
| Resize left (5) | `Ctrl-a H` |
| Resize down (5) | `Ctrl-a J` |
| Resize up (5) | `Ctrl-a K` |
| Resize right (5) | `Ctrl-a L` |
| **Copy Mode (vi)** | |
| Enter copy mode | `Ctrl-a Escape` |
| Begin selection | `v` |
| Copy selection | `y` |
| Paste | `Ctrl-a p` |
| Half-page down | `Space` |
| Half-page up | `Backspace` |
| **Clipboard** | |
| Copy to system clipboard | `Ctrl-a Ctrl-c` |
| Paste from system clipboard | `Ctrl-a Ctrl-v` |

**Plugins**: tpm, tmux-sensible, tmux-themepack (powerline/double/cyan), tmux-battery, tmux-yank

---

## Appendix C — VIM Cheatsheet

Based on: `.vimrc`

> Plugin manager: **vim-plug** | Theme: **Tomorrow-Night-Eighties**

| Action | Keybinding |
|--------|-----------|
| **General** | |
| Auto-indent entire file | `F7` |
| Toggle line numbers | `F9` |
| **NERDTree (file browser)** | |
| Toggle NERDTree | `Ctrl-n` |
| **Tagbar (code outline)** | |
| Toggle Tagbar | `F8` |
| **Search (ag/ack)** | |
| Search word under cursor | `K` (in `.vimrc2`) |
| Search prompt | `\` (backslash, in `.vimrc2`) |
| **CtrlP (fuzzy finder)** | |
| Open CtrlP | `Ctrl-p` |
| Search tags | `<leader>.` |
| **ctags** | |
| Jump to tag (vsplit) | `Ctrl-]` |
| **Tabs** | |
| New tab | `<leader>tc` |
| Close tab | `<leader>td` |
| Previous tab | `<leader>tp` |
| Next tab | `<leader>tn` |
| **Git** | |
| Git status | `:Gstatus` (vim-fugitive) |
| Git diff | `:Gdiff` |
| Inline diff | `<leader>vd` |
| **Whitespace** | |
| Strip on save | automatic (vim-better-whitespace) |
| DOS→Unix line endings | `<leader>du` |

**Plugin install**: Run `:PlugInstall` inside VIM.

---

## Appendix D — VIM Plugins Comparison

Comparison of plugins between the **active** config (`.vimrc`, vim-plug) and the **legacy** config (`.vimrc2`, Vundle).

| Plugin | `.vimrc` (active) | `.vimrc2` (legacy) | Notes |
|--------|:-----------------:|:------------------:|-------|
| **vim-airline** | — | ✅ | Status bar with powerline. Not in active config |
| **NERDTree** | ✅ (`Ctrl-n`) | ✅ (`F2`) | File browser. Both configs auto-open if no file given |
| **The Silver Searcher (ag)** | ✅ via ack.vim | ✅ via ag.vim | Backend for fast grep |
| **CtrlP** | ✅ | ✅ | Fuzzy finder |
| **ctags & cscope** | ✅ (ctags only) | ✅ (ctags + cscope) | `.vimrc2` has full cscope integration |
| **Tagbar** | ✅ (`F8`) | ✅ (`F3`) | Code outline sidebar |
| **YCM (YouCompleteMe)** | ❌ (commented out) | ✅ (conditional) | Autocomplete engine |
| **jedi-vim** | — | ✅ | Python-specific autocomplete |
| **vim-tmux-navigator** | — | ✅ | Seamless tmux/vim pane switching |
| **vim-fugitive** | ✅ | ✅ | Git wrapper |
| **vim-gitgutter** | ✅ | ✅ | Git diff signs in gutter |
| **vim-signify** | ✅ | — | VCS signs (git, hg, svn) |
| **vim-better-whitespace** | ✅ | — | Highlight and strip trailing whitespace |
| **indentLine** | ✅ | ✅ | Indent guides |
| **vim-pandoc** | ✅ | — | Pandoc/Markdown support |

### Recommendation

Use `.vimrc` (vim-plug) as the primary config. It is more modern and uses parallel plugin installation. If you need **vim-airline**, **cscope**, or **YCM**, cherry-pick those from `.vimrc2`.

---

## Appendix E — tar/gz Cheatsheet

> How to remember tar flags? Just **scream them**.

```
   GYAHHH.tar.gz
   │││││
   ││││└─ .gz  → z = gZip
   │││└── H    → (just screaming)
   ││└─── A    → (more screaming)
   │└──── Y    → (still screaming)
   └───── G    → (internal pain)
```

### Xtract Ze Filez !!!!

| Format | Command | Mnemonic |
|--------|---------|----------|
| `.tar.gz` | `tar -xzf gyahh.tar.gz` | **x**tract **z**e **f**ile !!!! |
| `.tar.bz2` | `tar -xjf hyahh.tar.bz2` | **x**tract **j**ustdoitnow **f**ile !!!! |
| `.tar.xz` | `tar -xJf aaagh.tar.xz` | **x**tract **J**USTDOITNOW **f**ile !!!! |
| `.tar` | `tar -xf calm.tar` | **x**tract **f**ile (no compression, no scream) |

### Compress Ze Filez !!!!

| Format | Command | Mnemonic |
|--------|---------|----------|
| `.tar.gz` | `tar -czf gyahh.tar.gz files/` | **c**ompress **z**e **f**ilez !!!! |
| `.tar.bz2` | `tar -cjf hyahh.tar.bz2 files/` | **c**ompress **j**ustpackit **f**ilez !!!! |
| `.tar.xz` | `tar -cJf aaagh.tar.xz files/` | **c**ompress... **J**UST... **f**ilez !!!! |

### Peek Inside (without extracting)

| Format | Command | Mnemonic |
|--------|---------|----------|
| `.tar.gz` | `tar -tzf gyahh.tar.gz` | **t**ell me what'**z** in the **f**ile |
| `.tar.bz2` | `tar -tjf hyahh.tar.bz2` | **t**ell me... **j**ust... the **f**ile |

### Quick Reference

```
 x = eXtract        c = Create         t = lisT
 z = gZip (.gz)      j = bzip2 (.bz2)   J = xz (.xz)
 f = File (always last, followed by filename)
 v = Verbose (optional, add if you like watching text fly by)
```

> **Pro tip**: `tar -xf` auto-detects compression on modern systems.
> But where's the fun in that? GYAHHH!
