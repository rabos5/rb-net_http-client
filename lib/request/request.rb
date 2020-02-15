# frozen_string_literal: true

require_relative 'schema'
require_relative '../core/core'
require_relative '../response/response'

module NetHTTP
  class Client
    def call_web_service(request_opts = {})
      @response = case request_opts[:method].to_s.upcase
                  when 'DELETE'
                    delete(request_opts)
                  when 'GET'
                    get(request_opts)
                  when 'POST'
                    post(request_opts)
                  when 'POST_FORM', 'POST_FORM_DATA'
                    post_form(request_opts)
                  when 'PUT'
                    put(request_opts)
                  else
                    logger.debug("Request method => '#{request_opts[:method]}' not yet supported.")
                    raise "Request method => '#{request_opts[:method]}' not yet supported."
                  end

      @response
    end

    def delete(opts = {})
      raise 'Empty DELETE request options provided.' if opts.empty?

      opts[:method] = 'delete'
      request_opts = request_opts(opts)
      path = if request_opts[:query]
               request_opts[:path] + request_opts[:query]
             else
               request_opts[:path]
             end

      logger.debug('Request Method => ' + request_opts[:method].to_s.upcase)
      logger.debug('Request Host => ' + request_opts[:uri].scheme.to_s + '://' + request_opts[:uri].host.to_s)
      logger.debug('Request Port => ' + request_opts[:uri].port.to_s)
      logger.debug('Request Path => ' + path)
      logger.debug('Request Headers =>')
      logger.debug(Hash[request_opts[:headers].to_h.map { |k, v| [k.to_s, v] }])
      NetHTTP::Response.new(
        response: client.delete(
          path
        ),
        logger: logger
      )
    end

    def get(opts = {})
      raise 'Empty GET request options provided.' if opts.empty?

      opts[:method] = 'get'
      request_opts = request_opts(opts)
      path = if request_opts[:query]
               request_opts[:path] + request_opts[:query]
             else
               request_opts[:path]
             end

      logger.debug('Request Method => ' + request_opts[:method].to_s.upcase)
      logger.debug('Request Host => ' + request_opts[:uri].scheme.to_s + '://' + request_opts[:uri].host.to_s)
      logger.debug('Request Port => ' + request_opts[:uri].port.to_s)
      logger.debug('Request Path => ' + path)
      logger.debug('Request Headers =>')
      logger.debug(Hash[request_opts[:headers].to_h.map { |k, v| [k.to_s, v] }])
      NetHTTP::Response.new(
        response: client.get(
          path,
          request_opts[:headers]
        ),
        logger: logger
      )
    end

    def post(opts = {})
      raise 'Empty POST request options provided.' if opts.empty?

      opts[:method] = 'post'
      request_opts = request_opts(opts)
      path = if request_opts[:query]
               request_opts[:path] + request_opts[:query]
             else
               request_opts[:path]
             end

      logger.debug('Request Method => ' + request_opts[:method].to_s.upcase)
      logger.debug('Request Host => ' + request_opts[:uri].scheme.to_s + '://' + request_opts[:uri].host.to_s)
      logger.debug('Request Port => ' + request_opts[:uri].port.to_s)
      logger.debug('Request Path => ' + path)
      logger.debug('Request Headers =>')
      logger.debug(Hash[request_opts[:headers].to_h.map { |k, v| [k.to_s, v] }])
      logger.debug('Request Body =>')
      logger.debug(request_opts[:body])
      NetHTTP::Response.new(
        response: client.post(
          path,
          request_opts[:body],
          request_opts[:headers]
        ),
        logger: logger
      )
    end

    def post_form(opts = {})
      raise 'Empty POST_FORM request options provided.' if opts.empty?

      opts[:method] = 'post_form'
      request_opts = request_opts(opts)
      path = if request_opts[:query]
               request_opts[:path] + request_opts[:query]
             else
               request_opts[:path]
             end

      logger.debug('Request Method => ' + request_opts[:method].to_s.upcase)
      logger.debug('Request Host => ' + request_opts[:uri].scheme.to_s + '://' + request_opts[:uri].host.to_s)
      logger.debug('Request Port => ' + request_opts[:uri].port.to_s)
      logger.debug('Request Path => ' + path)
      logger.debug('Request Headers =>')
      logger.debug(Hash[request_opts[:headers].to_h.map { |k, v| [k.to_s, v] }])
      logger.debug('Request Body =>')
      logger.debug(URI.encode_www_form(request_opts[:body]))
      NetHTTP::Response.new(
        response: client.post(
          path,
          URI.encode_www_form(request_opts[:body]),
          request_opts[:headers]
        ),
        logger: logger
      )
    end

    alias post_form_data post_form

    def put(opts = {})
      raise 'Empty PUT request options provided.' if opts.empty?

      opts[:method] = 'put'
      request_opts = request_opts(opts)
      path = if request_opts[:query]
               request_opts[:path] + request_opts[:query]
             else
               request_opts[:path]
             end

      logger.debug('Request Method => ' + request_opts[:method].to_s.upcase)
      logger.debug('Request Host => ' + request_opts[:uri].scheme.to_s + '://' + request_opts[:uri].host.to_s)
      logger.debug('Request Port => ' + request_opts[:uri].port.to_s)
      logger.debug('Request Path => ' + path)
      logger.debug('Request Headers =>')
      logger.debug(Hash[request_opts[:headers].to_h.map { |k, v| [k.to_s, v] }])
      logger.debug('Request Body =>')
      logger.debug(request_opts[:body])
      NetHTTP::Response.new(
        response: client.put(
          path,
          request_opts[:body],
          request_opts[:headers]
        ),
        logger: logger
      )
    end

    def request_opts(opts)
      schema_results = Core.schema_validation(opts, NetHTTP::Request::Schema.new) unless opts[:enforce_schema_validation] == false
      unless schema_results.nil?
        logger.debug("NetHTTP::Request::SchemaError -> #{schema_results}")
        raise NetHTTP::Request::SchemaError.new(schema_results.to_s)
      end

      request_method = opts[:method] || 'post'
      request_uri = Core::Utilities.parse_uri(opts[:uri] || opts[:url] || uri)
      request_path = (opts[:path] || request_uri.path || path).chomp('?')
      request_query = Core::Utilities.parse_query((opts[:query] || request_uri.query || query))
      request_headers = opts[:headers] || {}
      request_body = opts[:body] || nil

      {
        method: request_method,
        uri: request_uri,
        path: request_path,
        query: request_query,
        headers: request_headers,
        body: request_body
      }
    end
  end
end
