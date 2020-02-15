# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'NetHTTP::Client ext' do
  it 'returns a valid NetHTTP client instance with proxy_uri -> URI' do
    net_http_client = NetHTTP.client(
      uri: 'https://jsonplaceholder.typicode.com/posts',
      proxy_uri: 'http://proxy.com:8888'
    )

    expect(net_http_client.class).to eq(NetHTTP::Client)
    expect(net_http_client.proxy_uri.to_s).to eq('http://proxy.com:8888')
  end

  it 'returns a valid NetHTTP client instance with proxy_uri -> ""' do
    expect {
      NetHTTP.client(
        uri: 'https://jsonplaceholder.typicode.com/posts',
        proxy_uri: ''
      )
    }.to raise_error(NetHTTP::Client::SchemaError)
  end

  it 'returns a valid NetHTTP client instance with proxy_uri -> nil' do
    expect {
      NetHTTP.client(
        uri: 'https://jsonplaceholder.typicode.com/posts',
        proxy_uri: nil
      )
    }.to raise_error(NetHTTP::Client::SchemaError)
  end

  it 'returns a valid NetHTTP client instance with proxy_uri -> INVALID' do
    expect {
      NetHTTP.client(
        uri: 'https://jsonplaceholder.typicode.com/posts',
        proxy_uri: 12345
      )
    }.to raise_error(NetHTTP::Client::SchemaError)
  end

  it 'returns a valid NetHTTP client instance' do
    ENV['http_proxy'] = nil
    ENV['https_proxy'] = nil
    ENV['HTTP_PROXY'] = nil
    ENV['HTTPS_PROXY'] = nil

    net_http_client = NetHTTP.client(
      scheme: 'https',
      host: 'jsonplaceholder.typicode.com',
      port: 443,
      path: '/posts'
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

    net_http_client = NetHTTP.client(
      scheme: 'https',
      host: 'jsonplaceholder.typicode.com',
      port: 443,
      path: '/posts'
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
