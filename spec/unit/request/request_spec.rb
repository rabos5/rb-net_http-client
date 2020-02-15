# frozen_string_literal: true

require 'webmock/rspec'
require_relative '../../spec_helper'

describe 'NetHTTP::Client web service calls' do
  it 'makes a request with an invalid HTTP method' do
    net_http_client = NetHTTP.client(
      uri: 'https://jsonplaceholder.typicode.com/posts'
    )

    expect {
      net_http_client.call_web_service(
        method: 'DOES_NOT_EXIST'
      )
    }.to raise_error(RuntimeError, "Request method => 'DOES_NOT_EXIST' not yet supported.")
  end

  it 'makes a request with valid HTTP method => delete' do
    stub_request(
      :delete,
      'https://jsonplaceholder.typicode.com/posts'
    ).with(
      headers: request_headers,
      body: nil
    ).to_return(
      status: 200,
      headers: successful_post_response_headers,
      body: successful_post_response_body
    )

    net_http_client = NetHTTP.client(
      uri: 'https://jsonplaceholder.typicode.com/'
    )

    response = net_http_client.call_web_service(
      method: 'delete',
      path: '/posts'
    )

    expect(response.code.to_s).to eq('200')
    expect(response.headers).to eq(successful_post_response_headers)
    expect(response.headers_hash).not_to eq(nil)
    expect(response.headers_hash.class).to eq(Hash)
    expect(response.body).to eq(successful_post_response_body)
    expect(response.body_obj).not_to eq(nil)
    expect(response.body_obj.class).to eq(Hash)
  end

  it 'makes a request with valid HTTP method => get' do
    stub_request(
      :get,
      'https://jsonplaceholder.typicode.com/posts'
    ).with(
      headers: request_headers,
      body: nil
    ).to_return(
      status: 200,
      headers: successful_post_response_headers,
      body: successful_post_response_body
    )

    net_http_client = NetHTTP.client(
      uri: 'https://jsonplaceholder.typicode.com/'
    )

    response = net_http_client.call_web_service(
      method: 'get',
      path: '/posts'
    )

    expect(response.code.to_s).to eq('200')
    expect(response.headers).to eq(successful_post_response_headers)
    expect(response.headers_hash).not_to eq(nil)
    expect(response.headers_hash.class).to eq(Hash)
    expect(response.body).to eq(successful_post_response_body)
    expect(response.body_obj).not_to eq(nil)
    expect(response.body_obj.class).to eq(Hash)
  end

  it 'makes a request with valid HTTP method => post' do
    stub_request(
      :post,
      'https://jsonplaceholder.typicode.com/posts'
    ).with(
      headers: request_headers,
      body: nil
    ).to_return(
      status: 200,
      headers: successful_post_response_headers,
      body: successful_post_response_body
    )

    net_http_client = NetHTTP.client(
      uri: 'https://jsonplaceholder.typicode.com/'
    )

    response = net_http_client.call_web_service(
      method: 'post',
      path: '/posts'
    )

    expect(response.code.to_s).to eq('200')
    expect(response.headers).to eq(successful_post_response_headers)
    expect(response.headers_hash).not_to eq(nil)
    expect(response.headers_hash.class).to eq(Hash)
    expect(response.body).to eq(successful_post_response_body)
    expect(response.body_obj).not_to eq(nil)
    expect(response.body_obj.class).to eq(Hash)
  end

#   it 'makes a request with valid HTTP method => post_form' do
#      stub_request(
#       :post,
#       'https://jsonplaceholder.typicode.com/posts'
#     ).with(
#       headers: request_headers,
#       body: nil
#     ).to_return(
#       status: 200,
#       headers: successful_post_response_headers,
#       body: successful_post_response_body
#     )
# 
#     net_http_client = NetHTTP.client(
#       uri: 'https://jsonplaceholder.typicode.com/'
#     )
#     response = net_http_client.call_web_service(
#       method: 'post_form',
#       path: '/posts'
#     )
# 
#     expect(response.code.to_s).to eq('200')
#     expect(response.headers).to eq(successful_post_response_headers)
#     expect(response.headers_hash).not_to eq(nil)
#     expect(response.headers_hash.class).to eq(Hash)
#     expect(response.body).to eq(successful_post_response_body)
#     expect(response.body_obj).not_to eq(nil)
#     expect(response.body_obj.class).to eq(Hash)
#   end

  it 'makes a request with valid HTTP method => put' do
    stub_request(
      :put,
      'https://jsonplaceholder.typicode.com/posts'
    ).with(
      headers: request_headers,
      body: nil
    ).to_return(
      status: 200,
      headers: successful_post_response_headers,
      body: successful_post_response_body
    )

    net_http_client = NetHTTP.client(
      uri: 'https://jsonplaceholder.typicode.com/'
    )

    response = net_http_client.call_web_service(
      method: 'put',
      path: '/posts'
    )

    expect(response.code.to_s).to eq('200')
    expect(response.headers).to eq(successful_post_response_headers)
    expect(response.headers_hash).not_to eq(nil)
    expect(response.headers_hash.class).to eq(Hash)
    expect(response.body).to eq(successful_post_response_body)
    expect(response.body_obj).not_to eq(nil)
    expect(response.body_obj.class).to eq(Hash)
  end

  it 'successfully make a POST request' do
    stub_request(
      :post,
      'https://jsonplaceholder.typicode.com/posts'
    ).with(
      headers: request_headers,
      body: nil
    ).to_return(
      status: 200,
      headers: successful_post_response_headers,
      body: successful_post_response_body
    )

    net_http_client = NetHTTP.client(
      uri: 'https://jsonplaceholder.typicode.com/'
    )
    response = net_http_client.post(
      path: '/posts'
    )

    expect(response.code.to_s).to eq('200')
    expect(response.headers).to eq(successful_post_response_headers)
    expect(response.headers_hash).not_to eq(nil)
    expect(response.headers_hash.class).to eq(Hash)
    expect(response.body).to eq(successful_post_response_body)
    expect(response.body_obj).not_to eq(nil)
    expect(response.body_obj.class).to eq(Hash)
  end

  it 'makes a request with valid HTTP method => get with ? in request path' do
    stub_request(
      :get,
      "https://autotrader.com/cars-for-sale/searchresults.xhtml?searchRadius=0"
    ).with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Ruby'
      }
    ).to_return(
      status: 200,
      body: '',
      headers: {}
    )

    net_http_client = NetHTTP.client(
      uri: 'https://autotrader.com'
    )

    response = net_http_client.get(
      path: '/cars-for-sale/searchresults.xhtml',
      query: '?searchRadius=0'
    )

    expect(response.code.to_s).to eq('200')
    expect(response.headers).to eq({})
    expect(response.headers_hash).not_to eq(nil)
    expect(response.headers_hash.class).to eq(Hash)
    expect(response.body).to eq('')
    expect(response.body_obj).not_to eq(nil)
    expect(response.body_obj.class).to eq(Hash)
  end

  private

  def request_headers
    {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent' => 'Ruby'
    }
  end

  def successful_post_response_headers
    {
      'date' => 'Tue, 05 Mar 2019 22:44:58 GMT',
      'content-type' => 'application/json; charset=utf-8',
      'content-length' => '15',
      'connection' => 'close',
      'set-cookie' => '__cfduid=d9e01b81c42675802849336961ecd18371551825898; expires=Wed, 04-Mar-20 22:44:58 GMT; path=/; domain=.typicode.com; HttpOnly',
      'x-powered-by' => 'Express',
      'vary' => 'Origin, X-HTTP-Method-Override, Accept-Encoding',
      'access-control-allow-credentials' => 'true',
      'cache-control' => 'no-cache',
      'pragma' => 'no-cache',
      'expires' => '-1',
      'access-control-expose-headers' => 'Location',
      'location' => 'http://jsonplaceholder.typicode.com/posts/101',
      'x-content-type-options' => 'nosniff',
      'etag' => "W/'f-4jjw4Y8q22Yv1PV9m28FczJgjzk'",
      'via' => '1.1 vegur',
      'expect-ct' => "max-age=604800, report-uri='https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct'",
      'server' => 'cloudflare',
      'cf-ray' => '4b2f9e1b0c9dcd00-EWR'
    }
  end

  def successful_post_response_body
    '{
      "id": 101
    }'
  end
end
