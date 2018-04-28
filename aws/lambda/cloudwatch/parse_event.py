#!/usr/bin/env python

import os
import sys
import json
import re

with open('../test-data/event1.json', 'r') as f:
    jsonData = f.read()

j = json.loads(jsonData)
print(j['id'])

print(j['detail'])

print(j)
#print(jsonData)
#jsonStr = json.dumps(jsonData)
# jsonObj = json.loads(jsonStr.decode('string_escape'))
#
# print(type(jsonObj))

#print(jsonStr.decode('string_escape'))

#print(type(jsonObj))
# eventId = jsonObj["id"]
# #
# print(eventId)


