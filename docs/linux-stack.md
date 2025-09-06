# Linux Stack

After a long stint of using Windows as my host OS, I'm giving Linux a go. I really want to lean into using my Nvidia 3060 RTX and Valve's Proton for compatibility with things that are traditionally windows only. I also intend to use KVM with Windows 11 for all things with no obvious or sensible compatibility. Finally, I already manage a few VirtualBox VMs that I intend to continue except with KVM.

## Sway Into Shit

Getting started, I thought it would be straight forward to use `i3` ... but of course we're using Wayland now, so `sway` is the way to go. Initially loaded it up with nouevea and everything seemed great. Ny hopes were looking up. Next, load the nvidia drivers. To my surprise, `sway` will not work with nvidia proprietary drivers. In what f-ing world does it make sense that I have this brand f-ing new graphics framework that has abstractions that are so f-ing leaky that a major manufacturer of GPUs breaks the whole thing?! Ok, what is simple but not sway, something that works with nvidia drivers.

## Wayfire Dumpster Fire

Wayfire, start it up with `dbus-run-session wayfire` and you're presented with ... nothing. Configure it with the ability to start a terminal (e.g. foot) via Super+Enter and things start to become functional. This compositor is wild with the animations and ability to rotate windows to any angle. Great, lets attach bluetooth stuff ... install blueman ... that was more than expected. Ok, lets get a launcher .... wofi, easy and simple. Nice. Lets get a dock and something to let us have icons on the desktop, I'm too old to try to remember all of the applications on my computer. wf-shell comes with a dock ... buts its complete crap! It works, but its looks as ugly as a baboon butt hole and this is made worse by everything else in wayfire looking so good. WTF. 

Getting back to an application to allow icons on the desktop, there is desktopfolder that fell out of maintenance 5 years ago. I've read that an alternative is to use something like nemo-desktop. The trouble I had with this was that it constantly would get onto of windows, causing the windows to become unreachable with the mouse. OMG .... I just want a damn minimally working desktop. 

Finally, I ran through about 5 or 6 file managers, looking primarily for a file manager that provided a preview pane to see images and text files without actually opening an editor. Windows does it, WTF can't linux?! Apparently `dolphin` is the only editor that comes close.

Oh ... and for locking the screen, while sway doesn't work with nvidia ... apparently swaylock does work. So you use swaylock with wayfire. 

## Plasma Is A Winner ... So Far

After all of the horrible user experiences I observed with using wayfire, I had to take a step back and look at my options. I knew I had a bad taste of Gnome from some recent VM installs. I want to stay with things in the official Debian repos for now which include Xfce, Lxde (and the like), and KDE & Plasma. After doing some light comparisons and at my wits end with the nickel and diming of setup, I opted to go for KDE's Plasma environment (via `kde-standard` meta-package). I figured it should be the most balanced between customizable and mature of all the other desktop environments.

Everything that I had spent a whole day discovering and setting up with wayfire was done in about 30 minutes. Perfect! Moving on ... I now wanted to setup wezterm as a proper shortcut in the Plasma Dock. (I'll want to do this with all my staples, but starting with Wezterm). The key here is that you need to create the `.desktop` file, make it executable, run `kbuildsycoca6`, run it via Plasma's launcher, then pin it to the dock. There may be a more automatic way of doing this, but what is the point? If you need to restart all of plasma without restarting try `kquitapp5 plasmashell && kstart5 plasmashell`. (Something else missing from wayfire btw!)

## Nvidia Drivers

```
echo 'export KWIN_DRM_USE_EGL_STREAMS=0' | sudo tee /etc/profile.d/kwin-gbm.sh
sudo chmod +x /etc/profile.d/kwin-gbm.sh
echo 'export __GLX_VENDOR_LIBRARY_NAME=nvidia' | sudo tee /etc/profile.d/nvidia-gl.sh
sudo chmod +x /etc/profile.d/nvidia-gl.sh

sudo apt-get install pkg-config libglvnd0 libglvnd-dev libglvnd-core-dev

sudo systemctl set-default multi-user.target
sudo reboot
# Optionally: sudo nvidia-uninstall
sudo ./NVIDIA-Linux-x86_64-580.82.07.run
```

## Wezterm

I had been using the official Debian nvidia drivers, but I wanted to use the more upstream drivers. Not sure what the difference is in the configurations, but wezterm stopped working. Ugh! .... Anyways, falling back to software front_end seemed to work. After some twiddling, I was also able to get the OpenGL front_end to work so long as it has `enable_wayland = false`. WTF is happening here, why is this sooo shit? In any case, wezterm should be up and running with OpenGL using Nvidia 580 proprietary drivers.

**~/.config/wezterm/wezterm.lua**:

```
return {
  enable_wayland = false,
  front_end = "OpenGL",
  --front_end = "Software",
}
```

## KVM

```
sudo apt update
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

sudo systemctl status libvirtd
virsh list --all
```

File locations:

```
# VM definitions (XML files)
/etc/libvirt/qemu/

# VM disk images
/var/lib/libvirt/images/

# Network definitions
/etc/libvirt/qemu/networks/

# Log files
/var/log/libvirt/

virsh          # Primary CLI interface
virt-install   # VM creation tool
virt-clone     # VM cloning
virt-xml       # XML manipulation

virt-manager   # Desktop management interface
virt-viewer    # VM console viewer
```

"Default" Network Configuration:

```
virsh net-list --all
virsh net-define /usr/share/libvirt/networks/default.xml
virsh net-list --all
virsh net-start default
sudo virsh net-start default
virsh net-autostart default
```

The most efficient way to visualize the VM is via virt-viewer with spice-guest-tools installed.

## Windows VM

Note: During Windows 11 install, `Shift + F10` to pop terminal. Type `OOBE\BYPASSNRO` to reboot setup into mode that allows you to declare no internet and bypass the microsoft login step.

- Virtual Guest Drivers: `wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso`
- Spice Guest Tools: `https://spice-space.org/download/windows/spice-guest-tools/`

## Linux VM

Virtual Guest Drivers: `sudo apt install linux-modules-extra-$(uname -r)`

## Docker

```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## Pinta (Paint.Net Clone) Builder

Dockerfile

```
FROM debian:13

RUN apt-get update && apt-get install -y wget
RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb \
  && dpkg -i packages-microsoft-prod.deb

RUN apt-get update && apt-get install -y \
  dotnet-sdk-8.0 autotools-dev autoconf-archive gettext intltool \
  libadwaita-1-dev webp-pixbuf-loader

RUN wget https://github.com/PintaProject/Pinta/releases/download/3.0.3/pinta-3.0.3.tar.gz \
  && tar -xf pinta-3.0.3.tar.gz

RUN apt-get install -y build-essential

WORKDIR /pinta-3.0.3

RUN ./configure --prefix=/opt/pinta-linux-x64 && make install
WORKDIR /opt
RUN tar -zcf pinta-linux-x64.tar.gz pinta-linux-x64
```

build.sh

```
#!/bin/sh

mkdir -p context
docker build $@ -t pinta-builder -f Dockerfile context
```

## KDE Configurations

### Keybindings

I tried xkbcommon (no bueno with Wayland), I tried ~/.config/kglobalshortcutsrc and KDE reset the content when I reset the system (WTF?!). I don't want to spend any more time on this... you need to use the GUI with the following settings.

System Settings -> Shortcuts:

- Konsole -> Launch - Meta + Enter
- KRunner -> Launch - Meta + Space
- Audio Volume -> Decrease Volume - F13 (Tools)
- Audio Volume -> Increase Volume - F14 (Launch 5)
- Media Controller -> Media playback next - F15 (Launch 6)
- Media Controller -> Play/pause media playback - F16 (Launch 7)

### Dock General

I've configured the Dock to be the middle 40% of the screen and set so that windows go beneath it.

### Dock Launchers

Create the various `.desktop` files you want in `~/.local/share/applications`. For example:

```ini
[Desktop Entry]
Name=Spotify
Comment=Spotify Client
Keywords=music
Icon=spotify-client
TryExec=spotify
Exec=spotify
Type=Application
Categories=Entertainment
Terminal=false
```

Icons are stored in `~/.local/share/icons/` or you can use a upstream one from `/usr/share/icons/`. Mark the file with `chmod 755`. Optionally run `kbuildsycoca6` to force KDE to see your `.desktop` files.

Now, here is the bit that took forever for me to acknowledge... Whether it be GNOME, KDE, or something else. Don't treat a `.desktop` file like a shortcut in Windows. In Windows you can drag and drop these files into different locations and they just work, not the case in Linux. Instead, search for the `.desktop` instance in the DE's launcher and then copy or "pin" that discovered instance to docks or where ever. The is because we want the ever changing and 5% stable APIs used in these environments to deal with all of the commands and database updates that are needed to keep things coherent. Its not as elegant as a dotfile, but that is what you get when you try to use a Unix based system like its Windows or MacOS.

### Dock Widgets

I like to keep an eye on Disk Usage, CPU Usage, RAM Usage. I've added the following widgets to my setup for this:

- Disk Usage
- Individual Core Usage
- Memory Usage

IIRC, there are about a dozen other widgets that come default and I don't think any of them are worth removing atm.

## The Stack

- OS - Debian 13 Trixie
- Desktop Environment - KDE Plasma w/ Wayland
- Terminal - WezTerm (& Konsole via KDE)
- GPU Drivers - Nvidia Proprietary (535/550 from repos, maybe upstream?)
- Browser - Firefox (... eventually Zen & Chrome)

TODO:
- Hypervisor - KVM
- Tiling Options
- Keybindings

Software To Use:
- Container - Docker
- Godot
- Blender
- Paint.Net equivalent?
- Steam / Proton
- Screensaver






