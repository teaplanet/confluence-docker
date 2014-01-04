#!/bin/sh

# Database
/bin/sh /startup/initdb.sh

# Confluence
/bin/sh /startup/install-confluence.sh

# start daemon
/usr/bin/supervisord -n
