import json
import requests


class ChronografAPI:
    def __init__(self, host, source):
        self.host = host
        self.db_name = 'telegraf'
        self.retention_policy = 'price-estimation-rp'
        self.datasource = source

    def query(self, influxql_query):
        """
        Sends a query to the chronograf api to ask influx

        :param influxql_query str: the query to send to chronograf
        :returns dict: The json response parsed as a dictionary
        """
        body = {
            'query': influxql_query,
            'db': self.db_name,
            'rp': self.retention_policy,
            'tempVars': []
        }
        url = self.host + self.datasource['links']['proxy']
        r = requests.post(url, json=body)
        if r.status_code != 200:
            raise requests.HTTPError(r.text)
        return json.loads(r.text)


def get_sources(host):
    """
    Asks the chronograf api for its sources

    :param host str: the chronograf host to send the request to
    :returns list: The loaded json of sources
    """
    url = '{}/chronograf/v1/sources'.format(host)
    r = requests.get(url)
    if r.status_code != 200:
        raise requests.HTTPError(r.text)
    j = json.loads(r.text)
    if 'sources' not in j:
        raise ValueError('Sources not in sources json')
    return j['sources']
