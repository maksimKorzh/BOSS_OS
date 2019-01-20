# BOSS
Brainfuck Operating System Shell

![boss](https://github.com/maksimKorzh/BOSS/blob/master/boss.gif)

# Overview

    BOSS is a x86-arch 16-bit real-mode OS that consists of
    a simple system shell able to execute basic commands to
    manipulate the only source file and brainfuck interpreter
    to execute that file. You can create new file, edit it in
    a primitive text editor, load file/save file from floppy
    image, view it without editing and finally run.

# Run in emulator

    Tested with QEMU. To run the OS you must have qemu-system.
    
        $ qemu-system-i386 -fda BOSS.img

# Run on real hardware

    For now the only way I managed to run BOSS on real hardware
    is via Live USB, created with Unetbootin:
        
        - format USB flash drive to FAT32
        - open Unetbootin
        - choose Disk Image --> floppy option
        - open BOSS.img file
    
    After you're done open your flash drive with GParted to check
    out whether "boot" flag is on. If not - add it manually.
    
    It should boot...
    
    Note: it doesn't write source file to floppy image in Live USB mode

![video](https://www.youtube.com/watch?v=WeNI1k9--TQ)
