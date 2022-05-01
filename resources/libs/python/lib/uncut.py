
# Replace defaut maria scene for work with SotN-RandomStartRoom
# Because RandomStartRoom will load the cutscene version every time he enters


import os
from sys import modules

import shutil
import subprocess

from tkinter import Tk
from tkinter.messagebox import *
from tkinter.filedialog import askopenfilename


TITLE = "SotN-RandomStartRoom: Uncut"
CWD   = modules["__main__"].CWD
ICON  = CWD / "resources/images/icons/maria.ico"


try:
    import psutil
    import re
    def findFilesOpenedByEmuHawk(types='.bin', hawk='EmuHawk.exe'):
        # Return a list of opened files by processes matching 'name'.
        proc, ls = None, []
        for p in psutil.process_iter(['name']):
            if p.info['name'] == hawk:
                for nt in p.open_files():
                    # ls += [nt.path for t in types.split('|') if nt.path.endswith(t)]
                    # if nt.path.endswith('.bin') or nt.path.endswith('.iso'):
                    if re.match(f'.*?({types})', nt.path):
                        ls.append(nt.path)
                proc = p
                break
        return proc, ls
except:
    def findFilesOpenedByEmuHawk(*a, **k):
        return None, []

def getParent():
    w = Tk()
    w.wm_attributes('-topmost', 1)
    w.withdraw()
    w.iconbitmap(ICON)
    return w

def browse():
    parent = getParent()
    filename = askopenfilename(
        parent=parent,
        initialdir="",
        title=f"{TITLE} - Select your bin of SotN",
        filetypes=(("Bin files", "*.bin"),)
    )
    parent.destroy()
    return filename

def message(title, msg, dialog=showwarning):
    parent = getParent()
    dialog(title, msg, parent=parent)
    parent.destroy()


EmuHawk, files = findFilesOpenedByEmuHawk()
if files:
    src = files[0]
else:
    src = browse()
    if not src:
        print('User canceled!')

def patch():
    # unpatch this: https://github.com/3snowp7im/SotN-Randomizer/blob/c3fadff2cbc16edcb9b13f1f27b4fb2d552f3c93/src/randomize_relics.js#L526
    try:
        fh = open(src, "rb")
        fh.seek(0x0AEAA0)
        bt = [fh.read(1)]
        fh.seek(0x119AF4)
        bt += [fh.read(1)]
        fh.close()
        #print(bt)

        if bt == [b'\x1a', b'\x1a']:
            print('Maria: No patches required.')
            # message(TITLE,
                     # 'No patches are required.\n\n' + \
                     # 'This rom run with SotN-RandomStartRoom.\n\n' + \
                     # f'Rom: "{src}"', showinfo)

        elif bt[0] == b'\x00' or bt[1] == b'\x00':
            # print('Maria: Patches required.')
            fpath, ext = os.path.splitext(src)
            uncut = f'{fpath} (Maria Uncut){ext}'
            shutil.copy2(src, uncut)

            fh = open(uncut, "r+b")
            fh.seek(0x0AEAA0)
            fh.write((0x1A).to_bytes(1, "little"))
            fh.seek(0x119AF4)
            fh.write((0x1A).to_bytes(1, "little"))
            # fh.seek(0x054F0F46)
            # fh.write((0x1440).to_bytes(2, "little"))
            fh.close()

            # print(f'error_recalc.exe "{uncut}"')
            # print('Please wait...')

            recalc = CWD / "resources/libs/python/tools/error_recalc.exe"
            p = subprocess.Popen(f'{recalc} "{uncut}"', shell=True,
                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, stdin=subprocess.PIPE)
            output = p.stdout.read()
            # output = subprocess.getoutput(f'{recalc} "{uncut}"')

            if not output:
                message(TITLE,
                        'Maria cut scene removed!\n\n' + \
                        'Use this rom with SotN-RandomStartRoom.\n\n' + \
                        f'Rom: "{uncut}"')
                print('Maria: Cut scene removed.')
                # print(f'Use this rom "{uncut}" with SotN-RandomStartRoom')
            else:
                print(f'error_recalc.exe "{output}"')
                # message(TITLE, f'error_recalc.exe "{output}"', showerror)
        # else:
            # print('Byte', bt)
    except:
        from traceback import print_exc
        print_exc()
    os.system('pause')

if src:
    src = modules["__main__"].Path(src).resolve()
    patch()
