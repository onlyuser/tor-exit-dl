tor-exit-dl
===========

Copyright (C) 2011-2013 Jerry Chen <mailto:onlyuser@gmail.com>

About:
------

tor-exit-dl.sh is a bash script for finding Tor exit nodes.

Requirements:
-------------

* bash
* curl
* tor
* http://torstatus.blutmagie.de

Installation (Debian):
----------------------

1. git clone https://github.com/onlyuser/tor-exit-dl.git
2. sudo aptitude install curl

Usage:
------

1. Issue command "tor-exit-dl &lt;TOP_N&gt; [COUNTRY_CODE={US}]" into a bash terminal (not including brackets).
2. sudo vi /etc/tor/torrc
3. Append router names to the line that begins with "exitnodes" in file "torrc".
4. sudo /etc/init.d/tor restart

Keywords:
---------

    tor, exitnodes, bash, Linux
