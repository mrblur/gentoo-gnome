Unofficial GNOME overlay
[![Build Status](https://travis-ci.org/Heather/gentoo-gnome.png?branch=master)](https://travis-ci.org/Heather/gentoo-gnome)
[![Twitter][]](http://www.twitter.com/Cynede)
------------------------

Versions
--------

 - GNOME `3.28.x`
 - Pantheon `live` ebuilds

Communication
-------------

 - [Gentoo discord server](https://discord.gg/KEphgqH)
 - [issues](https://github.com/Heather/gentoo-gnome/issues)

Major differences with the main tree
-------------------------

 - To use the latest versions of vala, mask the old vala version to see the limitations. Currently, the only way to use the new vala is to port everything to this overlay.
 - gdbus-codegen was removed. (`666` version is just used for compatibility with tree packages)

Information
-----------
 - `list.py` lists packages inside the overlay and their versions.
 - The official [gnome overlay](http://git.overlays.gentoo.org/gitweb/?p=proj/gnome.git;a=summary).
 - Contributions are welcome.
 - For bugs, use [GitHub issues](https://github.com/Heather/gentoo-gnome/issues?state=open).
 - Use `pull --rebase` to resolve conflicts or set `branch.autosetuprebase = always`.
 - [This script](https://github.com/Heather/gentoo-gnome/blob/master/compare.py) removes features implemented upstream from this overlay.

Pantheon
--------

 - [This fix](http://elementaryos.stackexchange.com/questions/1946/have-application-menu-open-up-with-only-windows-key/2083#2083) was used for the Super_L key.
 - Entries from `/usr/share/gnome/autoload` are loaded.

Here is an example `.xinitrc`:

``` shell
#!/bin/sh
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#not sure about block below
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/gnome-settings-daemon/gnome-settings-daemon &
/usr/lib/gnome-user-share/gnome-user-share &
eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

#sometimes pantheon-session also will work
gsettings-data-convert &
xdg-user-dirs-gtk-update &
xrdb merge ~/.Xresources &&
wingpanel &
plank &
exec gala
```

Autostarting Plank in GNOME
---------------------------

add `/usr/share/gnome/autostart/plank.desktop`
```
[Desktop Entry]
Type=Application
Name=Plank
Comment=Plank panel
Exec=/usr/bin/plank
OnlyShowIn=GNOME;
X-GNOME-Autostart-Phase=Application
```

Likewise, `conky -d` can be added.

Branches
--------

 - `stable` branch was targeting `Sabayon 14.01`
 - `3.16` branch is saved old master
 - `master` branch is for newer stuff based on portage

[Twitter]: http://mxtoolbox.com/Public/images/twitter-icon.png
