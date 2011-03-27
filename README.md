CapIt!
======
CapIt provides a simple Ruby interface to Björn Höhrmann's 
[CutyCapt][1]. 

Install CutyCapt
----------------

### Ubuntu/Debian
(from [Setting up Headless XServer and CutyCapt on Ubuntu][2])

    sudo apt-get install xvfb
    sudo apt-get install xfs xfonts-scalable xfonts-100dpi
    sudo apt-get install libgl1-mesa-dri
    sudo apt-get install subversion libqt4-webkit libqt4-dev g++
    svn co https://cutycapt.svn.sourceforge.net/svnroot/cutycapt
    cd cutycapt/CutyCapt
    qmake
    make

You'll also need to make sure the `CutyCapt` executable is in your PATH.

### OSX (via Homebrew)

    brew install cuty_capt

Install CapIt
-------------
    gem install capit

Usage
-----
    require 'capit'
    capit = CapIt::Capture("http://www.github.com")

Notes
-----
Don't use this yet.

[1]: http://cutycapt.sourceforge.net/ "CutyCapt"
[2]: http://daveelkins.com/2009/04/10/setting-up-headless-xserver-and-cutycapt-on-ubuntu/ "Setting up Headless XServer and CutyCapt on Ubuntu"

