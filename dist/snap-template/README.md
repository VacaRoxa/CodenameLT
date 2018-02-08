# LÖVE Snap Template

## Introduction

This template is designed to make it easier for developers of games based on [LÖVE](https://love2d.org/) to package them up as snaps.

[Snaps](http/snapcraft.io/) allow you to "_Package any app for every Linux desktops, server, cloud or device, and deliver updates directly._"

Once you have built a snap, it can be [published](https://snapcraft.io/docs/build-snaps/publish) to the Ubuntu Store where it will be almost immediately available to millions of desktop users.

## tl;dr

On a machine running Ubuntu 16.04, install snapcraft:-

```
sudo apt update
sudo apt install snapcraft
```

Clone this template and modify occurrances of 'lovegame' throughout to match your game title. Update metadata and version of LÖVE required in ```snapcraft.yaml```. Add an icon and update the desktop file in ```snap/gui``` and rename & modify the last line of ```launcher/launch_lovegame```.

Drop your ```.love``` file in ```lovegame``` directory.

Run ```snapcraft``` to build the ```.snap``` file.

Install the resulting snap package:-

```
snap install lovegame_0.1_amd64.snap
```

Run it either by searching for your application in the menu, or from the command line directly.

[Publish](https://snapcraft.io/docs/build-snaps/publish) it to the store.

## Template Contents

Below is (I think) a comprehensive overview of the files contained in this repo along with how they should be modified for any given LÖVE game.

Once you're happy with the changes, run ```snapcraft``` from the top level directory on an Ubuntu 16.04 system to build a snap.

Further documentation about snaps can be found at [snapcraft.io](http://snapcraft.io). 

### lovegame/

The lovegame folder contains a basic 'hello world' LÖVE 'game'. Replace this with your game love file. Modify the launch_lovegame and snapcraft.yaml files as appropriate below.

### Desktop File & icon

```
snap/setup/lovegame.png
```

Replace the default png file with your own icon.

```
snap/setup/lovegame.desktop
```

Rename this to match the name at the top of the snapcraft.yaml - your short game name. Edit the file to reflect the name, description and executable (short game name), and icon name.

```
[Desktop Entry]
Name=LOVEGame
Comment=A Description of LOVEGame
Exec=lovegame
Icon=${SNAP}/meta/gui/lovegame.png
Terminal=false
Type=Application
Categories=Game;Simulation;
GenericName=
Keywords=game
```

### snapcraft.yaml

```
snap/snapcraft.yaml
```

This file is consumed by snapcraft. Modify it as below:-

#### Metadata

##### Game Name & Description

This section is pretty self-explanitory. The short and long description will appear in the store. The 'name' is just a short unique name for the package.

```
name: lovegame
version: "0.1"
summary: A Description of LÖVEGame
description: |
  A longer description of LÖVEGame.
```

##### Confinement policy

By default snaps are confined, with access to resources defined by the interfaces (plugs/sockets) in the next section. Leave this bit alone.

```
confinement: strict
grade: stable
```

##### Commands

Commands list the executable items in the snap. We're only going to have one executable (although more are possible), which is the launcher we use to setup the environment and launch the game.

The plugs list the resources that the game will have access to. Audio, graphics and network are common resources, so we wire up those plugs here.

_Note: The network-bind is listed here, but probably isn't needed. It's used when binding to a network port, such as when running a game server._

```
apps:
  lovegame:
    command: bin/launch_lovegame
    plugs:
      - pulseaudio
      - x11
      - network
      - network-bind
      - opengl
```

#### Parts

Snaps consist of multiple parts, pulled together at build time and compressed into a single squashfs file. There are three parts in this template.

 * Love Runtime
 * Game itself
 * Launcher script

##### LÖVE Runtime to include

The snap will contain both the game, support libraries and the LÖVE runtime. Comment / uncomment the relavent two sections for the version of LÖVE (and liblove) required by the game.

_Note: This section has multiple entries, most of which are commented out, as a convenience so you can choose which version of LÖVE you built for. Only uncomment one love and one liblove stanza._

```
parts:
#  love0.10.2:
#    plugin: copy
#    source: https://bitbucket.org/rude/love/downloads/love_0.10.2ppa1_amd64.deb
#  liblove0.10.2:
#    plugin: copy
#    source: https://bitbucket.org/rude/love/downloads/liblove0_0.10.2ppa1_amd64.deb
#  love0.10.1:
#    plugin: copy
#    source: https://bitbucket.org/rude/love/downloads/love_0.10.1ppa1_amd64.deb
#  liblove0.10.1:
#    plugin: copy
#    source: https://bitbucket.org/rude/love/downloads/liblove0_0.10.1ppa1_amd64.deb
#  love0.10.0:
#    plugin: copy
#    source: https://bitbucket.org/rude/love/downloads/love_0.10.0ppa1_amd64.deb
#  liblove0.10.0:
#    plugin: copy
#    source: https://bitbucket.org/rude/love/downloads/liblove0_0.10.0ppa1_amd64.deb
  love0.9.1:
    plugin: dump
    source: https://bitbucket.org/rude/love/downloads/love_0.9.1_amd64.deb
  liblove0.9.1:
    plugin: dump
    source: https://bitbucket.org/rude/love/downloads/liblove_0.9.1_amd64.deb
```

##### Game

Here's where your game is pulled into the snap. You can leave this as-is, or optionally change 'lovegame' to your game name.

Listed in 'stage-packages' are some dependencies which will be required in the snap to allow the end-user machine to run a LÖVE game. Leave this alone, unless you know you depend on some additional packages from the Ubuntu 16.04 archive. In which case add them to the list.

```
  lovegame:
    plugin: dump
    source: ./lovegame/
    stage-packages:
      - libgl1-mesa-dri
      - libgl1-mesa-glx
      - libglew1.13
      - lua-socket
```

##### Launcher

This adds the final part. A shell script which sets up the environment on the end user PC before launching the game.

```
  launcher:
    plugin: dump
    source: ./launcher
    organize:
      'launch_lovegame': 'bin/launch_lovegame'
```

### launch_lovegame

```
launcher/launch_lovegame
```

#### Launching the game

The only line which should need modification is the last one. Simply change the name of the parameter from 'lovegame.love' to whatever your game .love file is.

```
$SNAP/usr/bin/love $SNAP/lovegame.love
```

## Thanks

I used a version of this template to publish 'Oh My Giraffe' to the snap store. Thanks to those people who tested the game to help make this template.
