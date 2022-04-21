@ECHO off
CLS
COLOR 1B

REM Required for build:
REM - Python 3.10+      https://www.python.org/downloads/
REM - pyinstaller 4.10+ https://pypi.org/project/pyinstaller/
REM - psutil 5.9.0+     https://pypi.org/project/psutil/
REM - pywin32 303+      https://pypi.org/project/pywin32/


TITLE SotN-RandomStartRoom: Building python lib...


SET icon=../../images/maria.ico
SET PY=RandomStartRoom.py

CALL pyinstaller.exe --onefile --distpath=build --icon=%icon% %PY% --version-file=build_vf.txt

timeout 3 > NUL

COPY "build\RandomStartRoom.exe" "RandomStartRoom.exe"

timeout 5 > NUL

IF EXIST __pycache__ (
    RD __pycache__ /S /Q
)
IF EXIST build (
    RD build /S /Q
)
IF EXIST RandomStartRoom.spec (
    DEL RandomStartRoom.spec > NUL
)

PAUSE
