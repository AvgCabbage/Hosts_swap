# Hosts_swap
Script to switch between hosts file on android, primarily to block ads.

This script will compare the MD5 hash of */etc/hosts* to the MD5 of the *hosts.block* and *hosts.unblock* files and overwrite */etc/hosts* depending on what was previously used.  

*hosts.block* file not provided.
*hosts.unblock* is just a cp of */etc/hosts*.
