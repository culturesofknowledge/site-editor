__author__ = 'matthew'

from exporter.exporter import Exporter
from config import config

catalogue = 'BAYLEREADY'
debug_on = False
postgres_connection = "dbname='" + config["dbname"] + "'" \
                      + " host='" + config["host"] + "' port='" + config["port"] + "'" \
                      + " user='" + config["user"] + "' password='" + config["password"] + "'"

e = Exporter( postgres_connection, False, debug_on )

command = "select work_id from cofk_union_work where original_catalogue='" + catalogue + "'"

work_ids = e.select_all( command )
work_ids = [id['work_id'] for id in work_ids]

e.export( work_ids, catalogue )