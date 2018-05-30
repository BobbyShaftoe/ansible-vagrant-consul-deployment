from __future__ import print_function

import json
import logging
import socket
import ssl
from datetime import datetime

try:
    import custom_filter
except ImportError:
    custom_filter = None

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Parameters
es_index_prefix = 'cloudtrail'
host = "10.20.0.175"
metadata = {
    "local_metafields": {
        "backend": "python",
        "generator": "lambda"
    },
    "source": "cloudtrail"
}

# Constants
raw_port = 10514

# SSL security
# while creating the lambda function
enable_security = False
ssl_port = 10515


def lambda_handler(event, context):
    # Attach Logstash TCP Socket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    port = raw_port
    if enable_security:
        s = ssl.wrap_socket(s)
        port = ssl_port

    s.connect((host, port))

    # Add the context to meta
    metadata["aws"] = {}
    metadata["aws"]["function_name"] = context.function_name
    metadata["aws"]["function_version"] = context.function_version
    metadata["aws"]["invoked_function_arn"] = context.invoked_function_arn
    metadata["aws"]["memory_limit_in_mb"] = context.memory_limit_in_mb

    try:
        cloudtrail_event = process_cloudtrail_event(event)
        send_entry(s, cloudtrail_event)

    except Exception as e:
        # Logs through the socket the error
        err_message = 'Error parsing the object. Exception: {}'.format(str(e))
        send_entry(s, err_message)
        raise e
    finally:
        s.close()


# Handle Cloudtrail events
def process_cloudtrail_event(event):
    event_detail = event

    event_id = event_detail['id']
    event_account = event_detail['account']
    event_time = event_detail['time']
    date_time = datetime.strptime(event_time, '%Y-%m-%dT%H:%M:%SZ')
    date = date_time.strftime('%Y.%m')
    es_index = str(es_index_prefix + "-" + str(event_account) + "-" + str(date))
    event['es_index'] = es_index

    logger.info("Sending event: %s to logstash server: %s", event_id, host)
    return event


def send_entry(s, log_entry):
    # The log_entry can only be a string or a dict
    if isinstance(log_entry, str):
        log_entry = {"message": log_entry}
    elif not isinstance(log_entry, dict):
        raise Exception(
            "Cannot send the entry as it must be either a string or a dict. Provided entry: " + str(log_entry))

    # Send to Logstash
    log_entry = merge_dicts(log_entry, metadata)
    str_entry = json.dumps(log_entry)
    s.send((str_entry + "\n").encode("UTF-8"))


def merge_dicts(a, b, path=None):
    # if path is None:
    #     path = []
    # for key in b:
    #     if key in a:
    #         if isinstance(a[key], dict) and isinstance(b[key], dict):
    #             merge_dicts(a[key], b[key], path + [str(key)])
    #         elif a[key] == b[key]:
    #             pass  # same leaf value
    #         else:
    #             raise Exception(
    #                 'Conflict while merging metadatas and the log entry at %s' % '.'.join(path + [str(key)]))
    #     else:
    #         a[key] = b[key]
    merged = {**a, **b}

    return merged
