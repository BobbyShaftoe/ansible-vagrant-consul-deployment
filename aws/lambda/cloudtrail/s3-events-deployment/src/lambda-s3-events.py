import os
import re
import gzip
import boto3
import urllib.parse
from io import BytesIO as ByStrIO
import json
import logging
from elasticsearch import Elasticsearch

es_host = '10.20.0.175'
es_port = '9200'
es = Elasticsearch(host=es_host, port=es_port)

try:
    import custom_filter
except ImportError:
    custom_filter = None

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client('s3')


def lambda_handler(event, context):
    s3_event = event['Records'][0]['eventName']
    s3_log = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    s3_bucket = event['Records'][0]['s3']['bucket']['name']

    logger.info("Received s3 object event: " + s3_event + ":" + s3_bucket + ":" + s3_log + "\n")

    result = process_event(s3_bucket, s3_log)
    logger.info(result)


def process_event(bucket, log):
    try:
        gzip_json_pattern = re.compile('.*/(.*).json.gz$')
        re.search(gzip_json_pattern, log).group(1)
        log_file_name = os.path.basename(log)
        logger.info("Retrieving cloudtrail log from s3: " + log_file_name)
    except AttributeError:
        logger.warning("Pattern did not match any cloudtrail log: " + log)
        return "Exited"

    try:
        gzip_payload = ByStrIO()
        s3.download_fileobj(bucket, log, gzip_payload)
    except Exception as e:
        logger.error("Error: " + str(e))
        return "Failed"

    logger.info("Decompressing and reading cloudtrail log")

    try:
        gzip_payload.seek(0)
        json_file_compressed = gzip.GzipFile(fileobj=gzip_payload, mode='rb')
        json_file_bytes = json_file_compressed.read()
        json_file_compressed.close()
    except Exception as e:
        logger.fatal(e)
        return "Failed"

    json_file = json.loads(json_file_bytes.decode("utf-8"))

    if len(json_file['Records']) < 1:
        return "Failed: No event found in records"
    else:
        logger.info("Processing " + str(len(json_file['Records'])) + " events")

    c = 0
    for i in json_file['Records']:
        c += 1
        event_type, event_name, event_id = i['eventType'], i['eventName'], i['eventID']
        logger.info("[" + str(c) + "] "
                    + "Event Type: " + event_type + ", " + "Event Name: " + event_name + ", " + "Event ID: " + event_id)

        logger.info("Sending event to elasticsearch")

        if elasticsearch_put(i, bucket, event_id) == "Failed":
            return "Failed"

    return "Success"


def elasticsearch_put(event, index, event_id):
    try:
        res = es.index(index=index, doc_type='cloudtrail', id=event_id, body=event)
    except Exception as e:
        logger.fatal(e)
        return "Failed"

    logger.info(res['created'])
    return "Success"
