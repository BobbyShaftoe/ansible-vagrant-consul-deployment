#!/usr/bin/env python

import requests
import re

url = 'https://api.ipify.org?format=json'

ip_request = requests.get(url)
ip_response = ip_request.text

ip_match = re.match(r".*\b(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\b.*", ip_response)

if ip_match:
    ip_address = ip_match.group(1)
    print ip_address






