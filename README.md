# raspbian-pytorch-builder

## Description

Getting to build PyTorch for a Raspberry Pi can become a rabbit hole. This is why I put a series of script in order to do it and do it fast(ish).

These are the steps performed by the scripts:
* Download raspbian image (buster)
* Expand the filesystem
* Mount the image file in a loop device
* Chroot into the mounted device and:
  * Update, upgrade and install packages via apt
  * Clone pytorch repository
  * Compile and install PyTorch
* Unmount and clean

## **DISCLAIMERS**
* These scripts have been tested on macOS Mojave.
* In order to properly handle the loop devices the `--priviliged` flag is passed to the docker command. **Use it at your risk.**
* Make sure to configure docker with 5+ gigabytes of RAM and and as much cores you can spare. Compilation takes several hours, you may consider leaving it overnight.

## How to use it

The usage is quite simple, you just need to run the `build.sh`
