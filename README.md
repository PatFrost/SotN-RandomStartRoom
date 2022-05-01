
# SotN-RandomStartRoom
<p align="center">
  <a href="LICENSE" target="_blank"><img alt="License" src="https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat-square&logo=arduino"></a>
  <a href="https://github.com/PatFrost/SotN-RandomStartRoom/pulls" target="_blank"><img alt="PRs Welcome" src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg?style=flat-square&logo=arduino&logoColor=brightgreen"></a>
  <a href="https://github.com/PatFrost/SotN-RandomStartRoom/issues" target="_blank"><img alt="Issues" src="https://img.shields.io/badge/Suggest-Open%20Issue-brightgreen.svg?style=flat-square&logo=arduino&logoColor=brightgreen"></a>
  <a href="https://github.com/PatFrost/SotN-RandomStartRoom/issues" target="_blank"><img alt="Issues" src="https://img.shields.io/badge/Bugs-Issues-red.svg?style=flat-square&logo=arduino&logoColor=red"></a>
</p>

SotN-RandomStartRoom is tool for Castlevania: Symphony of the Night
running under <a href="https://tasvideos.org/BizHawk" target="_blank">BizHawk</a>.

## Features!
 - Random start room
 - Experimental: Randomize start equipements
 - Richter Vs. Dracula (Final Boss)
 - Richter Vs. Richter

## Requirements
 - <a href="http://redump.org/disc/3379/" target="_blank">Castlevania: Symphony of the Night (SLUS-00067) NTSC-U</a>
 - <a href="https://github.com/TASEmulators/BizHawk/releases" target="_blank">BizHawk 2.7 or higher</a>
   - Windows users must download and run the <a href="https://github.com/TASEmulators/BizHawk-Prereqs/releases" target="_blank">prereq installer</a> first.

 - **Optional**, but add cool stuff and increase speed to RandomStartRoom.
   - <a href="https://www.python.org/downloads/" target="_blank">Python 3.10 or higher</a> and make sure you select <a href="https://docs.python.org/3/using/windows.html#installation-steps" target="_blank">Add Python to PATH</a>
   - <a href="https://pypi.org/project/psutil/" target="_blank">psutil 5.9.0 or higher</a>
   - <a href="https://pypi.org/project/pywin32/" target="_blank">pywin32 303 or higher</a>
   - <a href="https://pypi.org/project/requests/" target="_blank">requests 2.27.1 or higher</a>

## Installation
Download <a href="https://github.com/PatFrost/SotN-RandomStartRoom/releases/latest" target="_blank">SotN-RandomStartRoom-v#.#.#.zip</a> and extract all to your BizHawk folder.

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
 1. Start Symphony of the Night under <a href="https://tasvideos.org/BizHawk" target="_blank">BizHawk</a>.
 2. If you used <a href="https://github.com/TalicZealot/SotnRandoTools" target="_blank">SotnRandoTools</a> start this tool before RandomStartRoom.lua
 3. Open Lua console under BizHawk and open/run RandomStartRoom.lua
 4. On game Symphony of the Night go to gamesave.
 5. On dialog window of SotN-RandomStartRoom press "OK" button.
 6. Now start new game.

## Known issues.
 - Random start equipment for hands and body does not work immediately! Work after enter in the settings.

## Recommended cool tools
 - <a href="https://github.com/TalicZealot/SotnRandoTools" target="_blank">SotnRandoTools</a>
 - <a href="https://sotn.io" target="_blank">SotN Randomizer</a>

**Cheers!!!**


<p align="center">
  <img alt="In Enter Olrox's Quarters" src="./resources/previews/preview1.jpg">
  <img alt="Richter Vs. Dracula" src="./resources/previews/preview2.jpg">
</p>
