
from json import loads
from pathlib import Path
from sys import argv, executable
from urllib.parse import parse_qsl
from traceback import print_exc


CWD = Path(__file__)
if executable.endswith("RandomStartRoom.exe"):
    CWD = Path(executable)
CWD = CWD.parents[3]

with open(CWD / "resources/default_settings.json") as j:
    VERSION = loads(j.read()).get("version", "1.0.0")
TITLE = f"SotN-RandomStartRoom - v{VERSION}"


class Params(dict):
    def __init__(self): self.update(dict(parse_qsl("".join(argv[1:]))))
    def __setattr__(self, key, value): self[key] = value
    def __getattr__(self, key): return self.get(key)
    def __getitem__(self, key): return self.get(key)

PARAMS = Params()

try:
    import atexit, ctypes, win32gui
    def setCursor(cursor=str(CWD / "resources/images/cursors/sword_nw.cur")):
        hold = win32gui.LoadImage(0, 32512, 2, 0, 0, 0x00008000)
        hold = ctypes.windll.user32.CopyImage(hold, 2, 0, 0, 0x00004000)
        hcur = win32gui.LoadImage(0, cursor, 2, 32, 32, 0x00000010)
        ctypes.windll.user32.SetSystemCursor(hcur, 32512)
        ctypes.windll.user32.DestroyCursor(hcur)
        @atexit.register
        def restore():
            # Restore the old cursor.
            ctypes.windll.user32.SetSystemCursor(hold, 32512)
            ctypes.windll.user32.DestroyCursor(hold)
    setCursor()

    if PARAMS.icon:
        HWND = win32gui.FindWindow(0, TITLE)
        if HWND:
            from win32api import SendMessage
            icon = str(CWD / "resources/images/icons/alucard.ico")
            SendMessage(HWND, 0x0080, 0, win32gui.LoadImage(0, icon, 1, 16, 16, 0x00000010)) # ICON_SMALL
            SendMessage(HWND, 0x0080, 1, win32gui.LoadImage(0, icon, 1, 48, 48, 0x00000010)) # ICON_BIG
            PARAMS.waitLuaEnd = 1 # for ICON_BIG work, wait end of main script

    if PARAMS.updater or PARAMS.icon:
        import lib.updater

    else:
        import lib.uncut

    if PARAMS.waitLuaEnd:
        from time import sleep
        win32gui.FlashWindowEx(HWND, 0x02, 3, 0)
        isvisible = win32gui.IsWindowVisible
        while isvisible(HWND): sleep(1)
except:
    print_exc()
    from os import system
    system('pause')
