#!/usr/bin/env python
# -*- coding: utf-8 -*-

from elasticsearch import Elasticsearch
from config import parser

# Core functions that are helpers
def getHits(esid, _index):
    # Connect to Elastic and get information about the connection.
    esserver = parser.get('es', 'es_url')
    esserver = [esserver]
    es = Elasticsearch(esserver)
    search = es.search(index=_index, doc_type="doc", body={"query": {"bool": {"must": { "match": { '_id' : esid }}}}})
    hits = search['hits']['total']
    if hits > 0:
        return search


