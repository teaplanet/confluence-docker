#!/bin/sh

# Database
/bin/sh /startup/initdb.sh

# start daemon
/usr/bin/supervisord -n
