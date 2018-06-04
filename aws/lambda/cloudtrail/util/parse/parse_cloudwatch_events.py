#!/usr/bin/env python

import sys
import json

try:
    file = sys.argv[1]
except IndexError as e:
    print("file?")
    sys.exit(1)

with open(file, "r") as f:
    json_bytes = f.read()


def flatten_json(y):
    out = {}

    def flatten(x, name=''):
        if type(x) is dict:
            for a in x:
                flatten(x[a], name + a + '_')
        elif type(x) is list:
            i = 0
            for a in x:
                flatten(a, name + str(i) + '_')
                i += 1
        else:
            out[name[:-1]] = x

    flatten(y)
    return out


json_body = json.loads(json_bytes)
json_body['resources'] = flatten_json(json_body['resources'])

json_body_detail = json_body['detail']
for j in json_body_detail:
    d = json_body_detail[j]
    if isinstance(d, list):
        json_body_detail[j] = flatten_json(d)

json_body['detail'] = json_body_detail


try:
    policyDocument = json_body_detail['requestParameters']['policyDocument']
    json_body_detail['requestParameters']['policyDocument'] = flatten_json(json.loads(policyDocument))
except KeyError as e:
    print('No policy document exists')

# detail.requestParameters.tagSpecificationSet.items
# detail.responseElements.statement
# detail.requestParameters.targets
# detail.responseElements.role.assumeRolePolicyDocument

print(json.dumps(json_body, indent=2))
