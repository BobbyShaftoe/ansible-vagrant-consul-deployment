import base64
import json
import urllib
import boto3
import socket
import ssl
import re
import zlib

structured_logs = []
bucket = 'test-s3-trail-logs'
key = 'AWSLogs/088841113972/CloudTrail/us-east-1/2018/05/25/088841113972_CloudTrail_us-east-1_20180525T0000Z_GRsTtcJF0xfFVNGJ.json.gz'

with open('../test-data/S3PutTestData/S3PutTestData.json', 'rt') as o:
    data = o.read()

cloud_trail = json.loads(data)

def merge_dicts(a, b, path=None):
    if path is None: path = []
    for key in b:
        if key in a:
            if isinstance(a[key], dict) and isinstance(b[key], dict):
                merge_dicts(a[key], b[key], path + [str(key)])
            elif a[key] == b[key]:
                pass  # same leaf value
            else:
                raise Exception(
                    'Conflict while merging metadatas and the log entry at %s' % '.'.join(path + [str(key)]))
        else:
            a[key] = b[key]
    return a



for event in cloud_trail['Records']:
    # Create structured object
    structured_line = merge_dicts(event, {"aws": {"s3": {"bucket": bucket, "key": key}}})
    structured_logs.append(structured_line)

print(json.dumps(structured_logs, indent=2))
