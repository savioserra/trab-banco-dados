from sqlalchemy import create_engine
import json

with open('config.json') as fp:
    configs = json.load(fp)

engine = create_engine('postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}'.format(**configs))
