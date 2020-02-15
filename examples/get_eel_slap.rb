# frozen_string_literal: true

require_relative 'helper'

net_http_client = NetHTTP.client(
  logger: @logger,
  uri: 'http://eelslap.com'
)

net_http_client.call_web_service(
  method: 'get',
  headers: {},
  path: '/'
)
