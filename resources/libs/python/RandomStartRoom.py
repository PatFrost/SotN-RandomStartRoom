
import os
from sys import argv, executable

TITLE = ""
try: TITLE = " ".join(argv[1:])
except: pass #TITLE = "SotN-RandomStartRoom - v1.0.0"

CWD = os.path.dirname(__file__)
if executable.endswith("RandomStartRoom.exe"):
    CWD = os.path.dirname(executable)
CWD = os.path.abspath(CWD+"../../../../")

if TITLE:
    try:
        #https://www.programcreek.com/python/example/53243/win32gui.LoadImage
        from win32api import SendMessage
        from win32gui import FindWindow, LoadImage
        from win32con import ICON_SMALL, ICON_BIG, IMAGE_ICON, LR_LOADFROMFILE, WM_SETICON

        icon = os.path.join(CWD, "resources", "images", "alucard.ico")

        hwnd = FindWindow(None, TITLE)
        if hwnd:
            icon_b = LoadImage(None, icon, IMAGE_ICON, 48, 48, LR_LOADFROMFILE)
            icon_s = LoadImage(None, icon, IMAGE_ICON, 16, 16, LR_LOADFROMFILE)
            SendMessage(hwnd, WM_SETICON, ICON_SMALL, icon_s)
            SendMessage(hwnd, WM_SETICON, ICON_BIG, icon_b)
            SendMessage(hwnd, WM_SETICON, ICON_BIG, icon_b)
    except:
        from traceback import print_exc
        print_exc()
        os.system('pause')

else:
    # Replace defaut maria scene for work with SotN-RandomStartRoom
    # Because RandomStartRoom will load the cutscene version every time he enters

    # import time
    # st = time.time()

    import shutil
    import subprocess

    from tkinter import Tk
    from tkinter.messagebox import *
    from tkinter.filedialog import askopenfilename

    try:
        import psutil
        import re
        def findFilesOpenedByEmuHawk(types='.bin', hawk='EmuHawk.exe'):
            "Return a list of opened files by processes matching 'name'."
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
        w.iconbitmap(os.path.join(CWD, "resources", "images", "maria.ico"))
        return w

    def browse():
        parent = getParent()
        filename = askopenfilename(
            parent=parent,
            initialdir="",
            title="SotN-RandomStartRoom - Uncut: Select your bin of SotN",
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
        # unpatch this:  https://github.com/3snowp7im/SotN-Randomizer/blob/c3fadff2cbc16edcb9b13f1f27b4fb2d552f3c93/src/randomize_relics.js#L526
        try:
            fh = open(src, "rb")
            fh.seek(0X0AEAA0)
            bt = [fh.read(1)]
            fh.seek(0X119AF4)
            bt += [fh.read(1)]
            fh.close()
            #print(bt)

            if bt == [b'\x1a', b'\x1a']:
                print('Maria: No patches required.')
                # message("SotN-RandomStartRoom: Maria Uncut",
                         # 'No patches are required.\n\n' + \
                         # 'This rom run with SotN-RandomStartRoom.\n\n' + \
                         # f'Rom: "{src}"', showinfo)

            elif bt[0] == b'\x00' or bt[1] == b'\x00':
                # print('Maria: Patches required.')
                fpath, ext = os.path.splitext(src)
                uncut = f'{fpath} (Maria Uncut){ext}'
                shutil.copy(src, uncut)

                fh = open(uncut, "r+b")
                fh.seek(0X0AEAA0)
                fh.write((0X1A).to_bytes(1, "little"))
                fh.seek(0X119AF4)
                fh.write((0X1A).to_bytes(1, "little"))
                # fh.seek(0X054F0F46)
                # fh.write((0x1440).to_bytes(2, "little"))
                fh.close()

                # print(f'error_recalc.exe "{uncut}"')
                # print('Please wait...')

                recalc = os.path.join(CWD, "resources", "libs", "python", "tools", "error_recalc.exe")
                p = subprocess.Popen(f'{recalc} "{uncut}"', shell=True,
                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT, stdin=subprocess.PIPE)
                output = p.stdout.read()
                # output = subprocess.getoutput(f'{recalc} "{uncut}"')

                if not output:
                    # print(time.time()-st)
                    message("SotN-RandomStartRoom: Maria Uncut",
                            'Maria cut scene removed!\n\n' + \
                            'Use this rom with SotN-RandomStartRoom.\n\n' + \
                            f'Rom: "{uncut}"')
                    print('Maria: Cut scene removed.')
                    # print(f'Use this rom "{uncut}" with SotN-RandomStartRoom')
                else:
                    print(f'error_recalc.exe "{output}"')
                    # message("SotN-RandomStartRoom: Maria Uncut", f'error_recalc.exe "{output}"', showerror)
            # else:
                # print('Byte', bt)
        except:
            from traceback import print_exc
            print_exc()
        os.system('pause')

    if src:
        src = os.path.normpath(src)
        patch()
    # print(time.time()-st)
