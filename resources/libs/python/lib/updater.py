
import os
import re
import time
import shutil
import zipfile
import tempfile
from sys import modules
from traceback import print_exc

import tkinter as tk
from tkinter.messagebox import *
from tkinter.ttk import Progressbar

import requests

Path    = modules["__main__"].Path
CWD     = modules["__main__"].CWD
CUR_VER = modules["__main__"].VERSION
TITLE   = "SotN-RandomStartRoom: Updater"
ICON    = CWD / "resources/images/icons/alucard.ico"


class Updater:
    def __init__(self, url):
        self.bname = os.path.basename(url)
        self.url = url

        self.open = True
        try:
            self.create()
            self.doModal()
        except:
            print_exc()

    def doModal(self):
        self.dp.after(100, self._dl_install)
        self.dp.eval('tk::PlaceWindow . center')
        self.dp.mainloop()

    def close(self):
        try: self.dp.destroy()
        except: pass
        self.open = False

    def create(self):
        self.dp = tk.Tk()
        self.dp.title(TITLE)
        self.dp.iconbitmap(ICON)
        self.dp.wm_attributes('-topmost', 1)
        self.dp.wm_attributes('-disabled', 1)

        self.dp_lbl = tk.Label(self.dp, font="20", height=3, wraplength=475)
        self.dp_lbl.grid(pady=5, padx=5)
        self.dp_lbl['text'] = f'Downloading: {self.bname}'

        self.dp_pbar = Progressbar(self.dp, orient=tk.HORIZONTAL, length=475, mode="determinate")
        self.dp_pbar.grid(padx=5)
        self.dp_pbar['value'] = 0

        tk.Label(self.dp, text='Please wait...', font="20").grid(pady=5, padx=5)

    def updateDP(self, pct, msg=None, title=None):
        self.dp_pbar['value'] = pct
        self.dp_pbar.update()
        if msg is not None:
            self.dp_lbl['text'] = msg
            self.dp_lbl.update()
        # self.dp.update_idletasks() # bug with wm -disabled
        if title:
            self.dp.title(f"{TITLE} {int(self.dp_pbar['value'])}%")
        else:
            self.dp.title(TITLE)

    def _dl_install(self):
        OK = False
        bs = 1024*8
        mb = 1024.0**2
        rd = 0
        st = time.time()
        size = 0

        tdir = os.path.join(tempfile.gettempdir(), "sotn_rsr_updater")
        tzip = os.path.join(tdir, self.bname)
        rdir = ""

        shutil.rmtree(tdir, ignore_errors=True)
        os.makedirs(tdir, exist_ok=True)
        try:
            # download
            with open(tzip, "wb") as oz:
                stream = requests.get(self.url, stream=True)
                result = tzip, stream.headers
                size = int(stream.headers['Content-Length'])
                mbSize = (size / mb)
                for data in stream.iter_content(chunk_size=bs):
                    rd += len(data)
                    oz.write(data)
                    self.updateDP(rd * 100.0 / size,
                             f"Downloading: {self.bname}" \
                             f"\nSize: {(rd / mb):.2f} / {mbSize:.2f} Mb" \
                             f" ({(rd / (time.time() - st) / mb):.2f} Mb/s)",
                             True)
            if size >= 0 and rd < size:
                raise Exception(f"Retrieval incomplete: got only {rd} out of {size} bytes", result)

            # extract all
            self.updateDP(0, f"Extracting: {self.bname}")
            with zipfile.ZipFile(tzip) as z:
                nlist = z.namelist()
                bdir = nlist[0]
                rdir = os.path.join(tdir, bdir.strip("/"))
                if len(nlist) != " ".join(nlist).count(bdir):
                    bdir = self.bname[:-4] #.replace(".zip", "")
                    tdir = rdir = os.path.join(tdir, bdir)
                shutil.rmtree(rdir, ignore_errors=True)
                # extract one by one
                # diff = 100.0 / len(nlist)
                # mbr = lambda m: re.sub('.*?/.*?/', '../../', m)
                # for i, member in enumerate(nlist, 1):
                    # self.updateDP(i*diff, f"Extracting: {self.bname}\n{mbr(member)}")
                    # z.extract(member, path=tdir)
                    # time.sleep(.025)
                    # print(i, member)
                z.extractall(tdir)
                self.updateDP(25, f"Extracting: {self.bname}")

            # install
            os.chdir(rdir)
            if len(list(Path().rglob('*')))+1 == len(nlist):
                self.updateDP(50, f'Installing: {self.bname[:-4]}')
                bak = CWD.parent / f'backup/{modules["__main__"].TITLE}'
                shutil.copytree(CWD, bak, dirs_exist_ok=True)
                self.updateDP(50)
                shutil.rmtree(CWD, ignore_errors=True)
                self.updateDP(75)
                shutil.copytree(rdir, CWD, dirs_exist_ok=True)
                self.updateDP(100)
                # shutil.rmtree(bak)

            OK = True
        except:
            print_exc()
            OK = False
        self.close()
        if OK:
            parent = getParent()
            showinfo(TITLE, f"{self.bname[:-4]}\nYou up to date.", parent=parent)
            parent.destroy()

def getParent():
    w = tk.Tk()
    w.wm_attributes('-topmost', 1)
    w.withdraw()
    w.iconbitmap(ICON)
    return w

def closeLuaConsole():
    from win32gui import FindWindow
    hwnd = FindWindow(None, 'Lua Console')
    if hwnd:
        from win32api import SendMessage
        SendMessage(hwnd, 0x0010, 0, 0)

def checkRelease():
    fjson = requests.get("https://api.github.com/repos/PatFrost/SotN-RandomStartRoom/releases/latest").json()
    latest = fjson["tag_name"].strip('v')
    if latest > CUR_VER:
        parent = getParent()
        if askyesno(TITLE, f"New release available.\nDo you want download new version {latest}",
                    parent=parent, icon="warning"):
            parent.destroy()
            closeLuaConsole()
            modules["__main__"].PARAMS.waitLuaEnd = None
            dp = Updater(fjson["assets"][0]["browser_download_url"])
            if dp.open: dp.close()
        else:
            parent.destroy()

checkRelease()
