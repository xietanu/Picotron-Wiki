# Using a Host OS terminal in Picotron

## Overview

This is a short guide designed to show you how to setup an environment to use [`printh`](/picotron_api/functions/printh/main.md) for debugging or logging.

## Windows:
### Step 1. Getting the path of your Picotron executable

This is typically found at `C:\Program Files (x86)\Picotron\picotron.exe` if you installed it, otherwise in the extracted folder if you are using the portable version of Picotron.

If it is not in this location, you can:
* open the start menu
* type Picotron
* press open file location
* click Picotron's executable
* press `CTRL+SHIFT+C` to copy the path

## Step 2. Creating the batch file

Now that you have the path, all you have to do is open any text editor and paste in the path, e.g:
`"C:\Program Files (x86)\Picotron\picotron.exe"`

You must ensure that there are double quotes `"` surrounding the path as seen above.

Save this file with the `.bat` extension, e.g: `picotron.bat`.

## Step 3. Running the batch file

Now once you run this batch file (the same as you would an exe), it will open up a terminal alongside Picotron.

When anything is printed to the terminal with `printh`, it will now appear in your host OS terminal.
