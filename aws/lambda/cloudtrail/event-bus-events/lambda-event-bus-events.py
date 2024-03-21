import logging
import json
from datetime import datetime
from elasticsearch import Elasticsearch


es_index_prefix = 'cloudtrail'
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

    event_detail = event

    event_id = event_detail['id']
    event_account = event_detail['account']
    event_time = event_detail['time']

    date_time = datetime.strptime(event_time, '%Y-%m-%dT%H:%M:%SZ')
    date = date_time.strftime('%Y.%m')

    es_index = str(es_index_prefix + "-" + str(event_account) + "-" + str(date))

    logger.info("Sending event to elasticsearch server: %s, index: %s, event id: %s", es_host, es_index, event_id)

    try:
        res = es.index(index=es_index, doc_type='cloudtrail', id=event_id, body=event)
        logger.info(res['created'])
        logger.info("Success")
    except Exception as e:
        logger.fatal(e)
        logger.info("Failed")




