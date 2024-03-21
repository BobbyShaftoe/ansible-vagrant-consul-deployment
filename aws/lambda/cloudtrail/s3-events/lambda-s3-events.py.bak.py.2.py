import re
import gzip
import boto3
import urllib.parse
from io import BytesIO as ByStrIO
import json
import logging


# from elasticsearch import Elasticsearch

es_host = '10.20.0.175'
es_port = '9200'
# es = Elasticsearch(host=es_host, port=es_port)

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


#    res = es.index(index="health", doc_type='metric', id=event['id'], body=event)
#    print(res['created'])

def process_event(bucket, log):
    gzip_json_file = ""
    gzip_json_pattern = re.compile('.*/(.*).json.gz$')
    gzip_payload = ByStrIO()

    try:
        gzip_json_file = "./" + re.search(gzip_json_pattern, log).group(1)
    except AttributeError:
        logger.warning("Pattern did not match any cloudtrail log: " + log)
        return "Failed"

    logger.info("Retrieving cloudtrail log from s3: " + gzip_json_file)

    try:
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
        return "Failed: " + str(e)

    json_file = json.loads(json_file_bytes.decode("utf-8"))

    if len(json_file['Records']) < 1:
        return "Failed: No event found in records"
    else:
        logger.info("Processing " + str(len(json_file['Records'])) + " events")

    c = 0
    for i in json_file['Records']:
        c += 1
        logger.info("[" + str(c) + "] "
                    + "Event Type: " + str(i['eventType']) + ", "
                    + "Event Name: " + str(i['eventName']) + ", "
                    + "Event ID: " + str(i['eventID']))

    return "Success"

