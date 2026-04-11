# Omarchy Rice Setup Guide

> **Author**: Przemysław Wandzilak
> **Last updated**: 2026-04-03
> **License**: Public

---

# Polish keyboard fix

```sh
nvim ~/.config/hypr/input.conf
input {
  # Use multiple keyboard layouts and switch between them with Left Alt + Right Alt
   kb_layout = pl #us,dk,eu

  # Use a specific keyboard variant if needed (e.g. intl for international keyboards)
  # kb_variant = intl

  kb_options = compose:caps,grp:altgr_toggle


```

# TMUX

Prefix remap to ctrl+a is a conflict with "Home" in Omarchy.

Omarchy uses Ctrl+Space.