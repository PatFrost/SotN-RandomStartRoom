
# SotN-RandomStartRoom
<p align="center">
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat-square&logo=arduino"></a>
  <a href="https://github.com/PatFrost/SotN-RandomStartRoom/pulls"><img alt="PRs Welcome" src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg?style=flat-square&logo=arduino&logoColor=brightgreen"></a>
  <a href="https://github.com/PatFrost/SotN-RandomStartRoom/issues"><img alt="Issues" src="https://img.shields.io/badge/Suggest-Open%20Issue-brightgreen.svg?style=flat-square&logo=arduino&logoColor=brightgreen"></a>
  <a href="https://github.com/PatFrost/SotN-RandomStartRoom/issues"><img alt="Issues" src="https://img.shields.io/badge/Bugs-Issues-red.svg?style=flat-square&logo=arduino&logoColor=red"></a>
</p>

SotN-RandomStartRoom is tool for Castlevania: Symphony of the Night
running under [BizHawk](https://tasvideos.org/BizHawk)

## Features!
 - Random start room.
 - Experimental: Randomize start equipements.
 - Richter Vs. Dracula (Final Boss)
 - Richter Vs. Richter

## Requirements
 - [Castlevania: Symphony of the Night (SLUS-00067) NTSC-U](http://redump.org/disc/3379/)
 - [BizHawk 2.7 or higher](https://github.com/TASEmulators/BizHawk/releases).
   - Windows users must download and run the [prereq installer](https://github.com/TASEmulators/BizHawk-Prereqs/releases) first.
 - 
 - **Optional**, but add cool stuff and increase speed to RandomStartRoom
   - [Python 3.10 or higher](https://www.python.org/downloads/) and make sure you select [Add Python to PATH](https://docs.python.org/3/using/windows.html#installation-steps)
   - [psutil 5.9.0 or higher](https://pypi.org/project/psutil/)
   - [pywin32 303 or higher](https://pypi.org/project/pywin32/)

## Installation
Download [SotN-RandomStartRoom-#.zip](https://github.com/PatFrost/SotN-RandomStartRoom/releases/latest) and extract all to your BizHawk folder.
File structure should look like this:
```
BizHawk
└───Lua
│   └───PSX
│   │   └───SotN-RandomStartRoom
│   │   │   - RandomStartRoom.lua <- is main script
│   │   │   - LICENSE
│   │   │   - README.md
│   │   │   - resources
│   │   │     └───...
```

## How to use RandomStartRoom
 1. Start Symphony of the Night under [BizHawk](https://tasvideos.org/BizHawk).
 2. If you used [SotnRandoTools](https://github.com/TalicZealot/SotnRandoTools) start this tool before RandomStartRoom.lua
 3. Open Lua console under BizHawk and open/run RandomStartRoom.lua
 4. On game Symphony of the Night go to gamesave.
 5. On dialog window of SotN-RandomStartRoom press "OK" button.
 6. Now start new game.

## Recommended cool tools
 - [SotnRandoTools](https://github.com/TalicZealot/SotnRandoTools) 
 - [SotN Randomizer](https://sotn.io)

**Cheers!!!**


<p align="center">
  <img alt="In Enter Olrox's Quarters" src="./resources/previews/preview1.jpg">
  <img alt="Richter Vs. Dracula" src="./resources/previews/preview2.jpg">
</p>
