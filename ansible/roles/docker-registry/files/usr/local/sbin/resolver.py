#!/usr/bin/env python
import socket
import sys

domain_name = sys.argv[1]

try:
    ip = socket.gethostbyname(domain_name)
    print ( ip )

except socket.gaierror:
    print ( "cannot resolve: " + domain_name )

