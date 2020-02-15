# frozen_string_literal: true

require_relative 'helper'

net_http_client = NetHTTP.client(
  logger: @logger,
  uri: 'https://jsonplaceholder.typicode.com'
)

net_http_client.post(
  path: '/posts'
)
