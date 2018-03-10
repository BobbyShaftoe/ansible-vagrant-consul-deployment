from elasticsearch import Elasticsearch

import json
import logging
import time

es_host = '10.20.0.175'
es_port = '9200'
es = Elasticsearch(host=es_host, port=es_port)

try:
   import custom_filter
except ImportError:
   custom_filter = None



logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    logger.info(event)
    print(event['id'])

    res = es.index(index="health", doc_type='metric', id=event['id'], body=event)
    print(res['created'])