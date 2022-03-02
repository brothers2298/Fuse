# ntapfuse - Capstone Project

My school account is arb204 - I am gathering projects from my school account and putting them here.

This was a project that I worked on with 3 colleagues to add multiple user quota functionality to the filesystem.


ntapfuse is a FUSE filesystem that mirrors a directory.


## Dependencies

The following packages need to be installed using

    $ sudo apt-get install <pkg-name>
* fuse
* libfuse-dev

## Building and Installing

In order to build and install ntapfuse, run the following commands from the
src directory:

    $ autoreconf --install
    $ ./configure
    $ make
    $ sudo make install

## Mounting the Filesystem

The filesystem can be mounted with the following command:

    $ ntapfuse mount <basedir> <mountpoint>
    
The basedir is the directory that is being mirrored. The mountpoint is the
directory that will act as a normal linux filesystem.

## Unmounting the filesystem

The filesystem can be unmounted with the following command:

    $ sudo umount <mountpoint>

