#!/bin/sh
sudo docker run -p 127.0.0.1:20022:22 -p 127.0.0.1:20080:8090 -v /data/confluence:/confluence:rw ken/confluence

# debug
#sudo docker run -i -t -p 127.0.0.1:20022:22 -p 127.0.0.1:20080:8090 -v /data/confluence:/confluence:rw ken/confluence /bin/bash
