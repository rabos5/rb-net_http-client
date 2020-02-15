# frozen_string_literal: true

require_relative 'helper'

net_http_client = NetHTTP.client(
  logger: @logger,
  uri: 'https://www.autotrader.com'
)

# any of the following examples work for query parameters
net_http_client.get(
  path: '/cars-for-sale/searchresults.xhtml?makeCodeList=JEEP&modelCodeList=WRANGLER'
)

# query_param keys can be string or symbol
query = {
  'makeCodeList': 'JEEP',
  'modelCodeList': 'WRANGLER'
}

net_http_client.get(
  path: '/cars-for-sale/searchresults.xhtml',
  query: query
)

net_http_client.get(
  path: '/cars-for-sale/searchresults.xhtml',
  query: 'makeCodeList=JEEP&modelCodeList=WRANGLER'
)
