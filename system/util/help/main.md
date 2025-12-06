# folder [path]

## Overview

Prints helpful cheatsheet for Picotron

Source: [source.lua](source.lua)

## Output

    - Picotron Cheatsheet
        
        ls (or dir)       \fd list files in the current folder\
        cd <directory>    \fd change directory (folder)\
        mkdir <directory> \fd create a directory\
        load <filename>   \fd load a cartridge (.p64) into /ram/cart\
        save <filename>   \fd save /ram/cart back to a .p64 file\
        reset             \fd reset draw state\
        
        CTRL-R            \fd run the loaded cartridge\
        ESC               \fd stop program or toggle between editor and output\
        CTRL-L            \fd clear the terminal\
        
        To try out a demo:
        $ cd /system/demos\
        $ load highway\

        .. and then CTRL-R to run it\