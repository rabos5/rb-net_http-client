# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'NetHTTP::Core::Utilities' do
  it 'constructs valid URI' do
    uri = {
      scheme: 'https',
      host: 'www.google.com',
      port: 443,
      path: '/search',
      query: 'q=ruby+uri'
    }

    uri = NetHTTP::Core::Utilities.construct_uri(uri)
    expect(uri).to eq('https://www.google.com/search?q=ruby+uri')
    expect(uri.class).to eq(String)

    parsed_uri = URI(uri)
    expect(parsed_uri.scheme).to eq('https')
    expect(parsed_uri.host).to eq('www.google.com')
    expect(parsed_uri.port).to eq(443)
    expect(parsed_uri.path).to eq('/search')
    expect(parsed_uri.query).to eq('q=ruby+uri')
  end

  it 'constructs valid URI when uri[:scheme] is missing' do
    uri = {
      host: 'www.google.com',
      port: 443,
      path: '/search',
      query: 'q=ruby+uri'
    }

    uri = NetHTTP::Core::Utilities.construct_uri(uri)
    expect(uri).to eq('https://www.google.com/search?q=ruby+uri')
    expect(uri.class).to eq(String)

    parsed_uri = URI(uri)
    expect(parsed_uri.scheme).to eq('https')
    expect(parsed_uri.host).to eq('www.google.com')
    expect(parsed_uri.port).to eq(443)
    expect(parsed_uri.path).to eq('/search')
    expect(parsed_uri.query).to eq('q=ruby+uri')
  end

  it 'constructs valid URI when uri[:port] is missing' do
    uri = {
      scheme: 'https',
      host: 'www.google.com',
      path: '/search',
      query: 'q=ruby+uri'
    }

    uri = NetHTTP::Core::Utilities.construct_uri(uri)
    expect(uri).to eq('https://www.google.com/search?q=ruby+uri')
    expect(uri.class).to eq(String)

    parsed_uri = URI(uri)
    expect(parsed_uri.scheme).to eq('https')
    expect(parsed_uri.host).to eq('www.google.com')
    expect(parsed_uri.port).to eq(443)
    expect(parsed_uri.path).to eq('/search')
    expect(parsed_uri.query).to eq('q=ruby+uri')
  end

  it 'constructs valid URI when uri[:scheme] is missing' do
    uri = {
      host: 'www.google.com',
      port: 80,
      path: '/search',
      query: 'q=ruby+uri'
    }

    uri = NetHTTP::Core::Utilities.construct_uri(uri)
    expect(uri).to eq('http://www.google.com/search?q=ruby+uri')
    expect(uri.class).to eq(String)

    parsed_uri = URI(uri)
    expect(parsed_uri.scheme).to eq('http')
    expect(parsed_uri.host).to eq('www.google.com')
    expect(parsed_uri.port).to eq(80)
    expect(parsed_uri.path).to eq('/search')
    expect(parsed_uri.query).to eq('q=ruby+uri')
  end

  it 'constructs valid URI when uri[:port] is missing' do
    uri = {
      scheme: 'http',
      host: 'www.google.com',
      path: '/search',
      query: 'q=ruby+uri'
    }

    uri = NetHTTP::Core::Utilities.construct_uri(uri)
    expect(uri).to eq('http://www.google.com/search?q=ruby+uri')
    expect(uri.class).to eq(String)

    parsed_uri = URI(uri)
    expect(parsed_uri.scheme).to eq('http')
    expect(parsed_uri.host).to eq('www.google.com')
    expect(parsed_uri.port).to eq(80)
    expect(parsed_uri.path).to eq('/search')
    expect(parsed_uri.query).to eq('q=ruby+uri')
  end

  it 'constructs valid URI when uri[:port], uri[:path], uri[:query] are missing' do
    uri = {
      scheme: 'https',
      host: 'www.google.com'
    }

    uri = NetHTTP::Core::Utilities.construct_uri(uri)
    expect(uri).to eq('https://www.google.com')
    expect(uri.class).to eq(String)

    parsed_uri = URI(uri)
    expect(parsed_uri.scheme).to eq('https')
    expect(parsed_uri.host).to eq('www.google.com')
    expect(parsed_uri.port).to eq(443)
    expect(parsed_uri.path).to eq('')
    expect(parsed_uri.query).to eq(nil)
  end

  it 'construct uri returns nil if uri is empty' do
    uri = {
    }

    uri = NetHTTP::Core::Utilities.construct_uri(uri)
    expect(uri).to eq(nil)
  end

  it 'construct uri returns nil if uri[:host] is missing' do
    uri = {
      host: nil
    }

    uri = NetHTTP::Core::Utilities.construct_uri(uri)
    expect(uri).to eq(nil)
  end

  it 'construct uri returns nil if uri[:scheme] && uri[:port] are missing' do
    uri = {
      host: 'www.google.com',
      path: '/search'
    }

    uri = NetHTTP::Core::Utilities.construct_uri(uri)
    expect(uri).to eq(nil)
  end

  it 'parses valid uri when no scheme is provided, only port => 443' do
    uri = 'www.google.com:443'

    parsed_uri = NetHTTP::Core::Utilities.parse_uri(uri)
    expect(parsed_uri.scheme).to eq('https')
    expect(parsed_uri.host).to eq('www.google.com')
    expect(parsed_uri.port).to eq(443)
    expect(parsed_uri.path).to eq('')
    expect(parsed_uri.query).to eq(nil)
  end

  it 'parses valid uri when no scheme is provided, only port => 80' do
    uri = 'www.google.com:80'

    parsed_uri = NetHTTP::Core::Utilities.parse_uri(uri)
    expect(parsed_uri.scheme).to eq('http')
    expect(parsed_uri.host).to eq('www.google.com')
    expect(parsed_uri.port).to eq(80)
    expect(parsed_uri.path).to eq('')
    expect(parsed_uri.query).to eq(nil)
  end

  it 'checks if valid xml document is valid XML' do
    xml_doc = '''
<note>
<to>Tove</to>
<from>Jani</from>
<heading>Reminder</heading>
<body>Do not forget me this weekend!</body>
</note>
    '''

    valid_xml = NetHTTP::Core::Utilities.valid_xml?(xml_doc)
    expect(valid_xml).to eq(true)
  end

  it 'checks if valid html document is valid HTML' do
    html_doc = '''
<!DOCTYPE html>
<html>
<body>
<h1>My First Heading</h1>
<p>My first paragraph.</p>
</body>
</html>
    '''

    valid_html = NetHTTP::Core::Utilities.valid_html?(html_doc)
    expect(valid_html).to eq(true)
  end

  it 'checks if invalid xml document is valid XML' do
    xml_doc = '''
<note>
<to>Tove</to>
<from>Jani</from>
<heading>Reminder</heading>
<body>Do not forget me this weekend!</body>
    '''

    valid_xml = NetHTTP::Core::Utilities.valid_xml?(xml_doc)
    expect(valid_xml).to eq(false)
  end

  it 'checks if invalid html document is valid HTML' do
    html_doc = '''
<!DOCTYPE html>
<html>
<body>
<h1>My First Heading
<p>My first paragraph.
</body>
</html>
    '''

    valid_html = NetHTTP::Core::Utilities.valid_html?(html_doc)
    expect(valid_html).to eq(false)
  end

  it 'returns snake case string key when camel case string key and type nil is provided' do
    new_key = NetHTTP::Core::Utilities.camel_2_snake('stringKey')
    expect(new_key).to eq('string_key')
  end

  it 'returns camel case string key when snake case string key and type nil is provided' do
    new_key = NetHTTP::Core::Utilities.snake_2_camel('string_key')
    expect(new_key).to eq('stringKey')
  end

  it 'returns snake case symbol key when camel case symbol key and type nil is provided' do
    new_key = NetHTTP::Core::Utilities.camel_2_snake(:symbolKey)
    expect(new_key).to eq(:symbol_key)
  end

  it 'returns camel case symbol key when snake case symbol key and type nil is provided' do
    new_key = NetHTTP::Core::Utilities.snake_2_camel(:symbol_key)
    expect(new_key).to eq(:symbolKey)
  end

  it 'returns snake case symbol key when camel case string key and type symbol is provided' do
    new_key = NetHTTP::Core::Utilities.camel_2_snake('stringKey', 'symbol')
    expect(new_key).to eq(:string_key)
  end

  it 'returns camel case symbol key when snake case string key and type symbol is provided' do
    new_key = NetHTTP::Core::Utilities.snake_2_camel('string_key', 'symbol')
    expect(new_key).to eq(:stringKey)
  end

  it 'returns snake case string key when camel case symbol key and type string is provided' do
    new_key = NetHTTP::Core::Utilities.camel_2_snake(:symbolKey, 'string')
    expect(new_key).to eq('symbol_key')
  end

  it 'returns camel case string key when snake case symbol key and type string is provided' do
    new_key = NetHTTP::Core::Utilities.snake_2_camel(:symbol_key, 'string')
    expect(new_key).to eq('symbolKey')
  end

  it 'returns snake case string key when camel case string key and type string is provided' do
    new_key = NetHTTP::Core::Utilities.camel_2_snake('stringKey', 'string')
    expect(new_key).to eq('string_key')
  end

  it 'returns camel case string key when snake case string key and type string is provided' do
    new_key = NetHTTP::Core::Utilities.snake_2_camel('string_key', 'string')
    expect(new_key).to eq('stringKey')
  end

  it 'returns snake case symbol key when camel case symbol key and type symbol is provided' do
    new_key = NetHTTP::Core::Utilities.camel_2_snake(:symbolKey, 'symbol')
    expect(new_key).to eq(:symbol_key)
  end

  it 'returns camel case symbol key when snake case symbol key and type symbol is provided' do
    new_key = NetHTTP::Core::Utilities.snake_2_camel(:symbol_key, 'symbol')
    expect(new_key).to eq(:symbolKey)
  end
end
