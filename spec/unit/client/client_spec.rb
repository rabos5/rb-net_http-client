# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'NetHTTP.client' do
  it 'returns a valid NetHTTP client instance' do
    ENV['http_proxy'] = nil
    ENV['https_proxy'] = nil
    ENV['HTTP_PROXY'] = nil
    ENV['HTTPS_PROXY'] = nil

    net_http_client = NetHTTP.client(
      uri: 'https://jsonplaceholder.typicode.com/posts'
    )

    expect(net_http_client.class).to eq(NetHTTP::Client)
    expect(net_http_client.logger.class).to eq(Logger)
    expect(net_http_client.logger.level).to eq(Logger::INFO)
    expect(net_http_client.uri.to_s).to eq('https://jsonplaceholder.typicode.com/posts')
    expect(net_http_client.proxy_uri.to_s).to eq('')
    expect(net_http_client.use_ssl).to eq(true)
    expect(net_http_client.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
    expect(net_http_client.open_timeout).to eq(60)
    expect(net_http_client.read_timeout).to eq(60)
  end

  it 'returns a valid NetHTTP client instance' do
    ENV['http_proxy'] = nil
    ENV['https_proxy'] = nil
    ENV['HTTP_PROXY'] = nil
    ENV['HTTPS_PROXY'] = nil

    net_http_client = NetHTTP::Client.new(
      uri: 'https://jsonplaceholder.typicode.com/posts'
    )

    expect(net_http_client.class).to eq(NetHTTP::Client)
    expect(net_http_client.logger.class).to eq(Logger)
    expect(net_http_client.logger.level).to eq(Logger::INFO)
    expect(net_http_client.uri.to_s).to eq('https://jsonplaceholder.typicode.com/posts')
    expect(net_http_client.proxy_uri.to_s).to eq('')
    expect(net_http_client.use_ssl).to eq(true)
    expect(net_http_client.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
    expect(net_http_client.open_timeout).to eq(60)
    expect(net_http_client.read_timeout).to eq(60)
  end
end
