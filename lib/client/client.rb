# frozen_string_literal: true

require 'net/https'
require_relative 'ext'
require_relative 'schema'
require_relative '../core/core'
require_relative '../response/response'
require_relative '../request/request'

module NetHTTP
  class Client
    attr_reader :ca_file,
                :cert,
                :client,
                :key,
                :logger,
                :open_timeout,
                :pkcs12,
                :pkcs12_file,
                :pkcs12_passphrase,
                :proxy_from_env,
                :proxy_uri,
                :proxy_url,
                :query,
                :read_timeout,
                :response,
                :ssl_path,
                :uri,
                :url,
                :use_proxy,
                :use_ssl,
                :verify_mode

    def initialize(opts = {})
      send('logger=', opts[:logger])
      schema_results = Core.schema_validation(opts, NetHTTP::Client::Schema.new) unless opts[:enforce_schema_validation] == false
      unless schema_results.nil?
        logger.debug("NetHTTP::Client::SchemaError -> #{schema_results}")
        raise NetHTTP::Client::SchemaError.new(schema_results.to_s)
      end

      send('uri=', opts)
      send('proxy_uri=', opts)
      send('client=', opts)
    end

    def client=(opts = {})
      if proxy_uri
        @client = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port).new(uri.host, uri.port)
      else
        @client = Net::HTTP.new(uri.host, uri.port)
      end

      send('proxy_from_env=', opts[:proxy_from_env])
      send('open_timeout=', (opts[:open_timeout] || 60))
      send('read_timeout=', (opts[:read_timeout] || 60))
      send('use_ssl=', opts[:use_ssl], uri.scheme)
      send('ssl_path=', opts[:ssl_path])
      send('pkcs12_file=', opts[:pkcs12_file])
      send('pkcs12_passphrase=', opts[:pkcs12_passphrase])
      send('pkcs12=')
      send('cert=')
      send('key=')
      send('ca_file=', opts[:ca_file])
      send('verify_mode=', opts[:verify_mode])

      @client.proxy_from_env = proxy_from_env
      @client.open_timeout = open_timeout
      @client.read_timeout = read_timeout
      @client.use_ssl = use_ssl
      if use_ssl
        @client.cert = cert
        @client.key = key
        @client.ca_file = ca_file
        @client.verify_mode = verify_mode
      end
    end

    private :response

    def logger=(logger = nil)
      @logger = Core.get_logger(logger)
    end

    alias proxy_url proxy_uri
    alias url uri
  end

  module_function

  def client(opts = {})
    Client.new(opts)
  end
end
