tor-exit-dl
==========

Copyright (C) 2011-2013 Jerry Chen <mailto:onlyuser@gmail.com>

About:
------

tor-exit-dl.sh is a bash script for finding Tor exit nodes.

Requirements:
-------------

* bash
* curl

Installation (Debian):
----------------------

1. git clone https://github.com/onlyuser/tor-exit-dl.git
2. sudo aptitude install curl

Usage:
------

1. sudo vi /etc/tor/torrc
2. Append router names to the line that begins with "exitnodes" in file "torrc"
3. sudo /etc/init.d/tor restart

Keywords:
---------

    tor-exit, bash, Linux
