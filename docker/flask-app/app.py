from flask import Flask
from redis import Redis
import sys

try:
    db_host = sys.argv[1]
except IndexError:
    db_host = 'redis'

app = Flask(__name__)
redis = Redis(host=db_host, port=6379)

@app.route('/')
def hello():
    count = redis.incr('hits')
    return 'Hello World! I have been seen {} times.\n'.format(count)

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)

