# frozen_string_literal: true

require 'json'
require 'nokogiri'
require 'ostruct'
require_relative '../core/core'
require_relative '../core/utilities'

module NetHTTP
  class Response
    attr_reader :code,
                :body,
                :body_obj,
                :body_os,
                :headers,
                :headers_hash,
                :headers_os,
                :logger,
                :response

    def initialize(opts = {})
      send('logger=', opts[:logger])
      @response = opts[:response]
      send('response=', opts[:response])
      send('code=')
      send('headers=')
      send('headers_hash=')
      send('headers_os=')
      send('body=')
      send('body_obj=')
      send('body_os=')
      log_response
    end

    def body=
      @body = response.body
    end

    def body_obj=
      @body_obj = {}

      if content_type.to_s.downcase.include?('json')
        @body_obj = parse_json(body, logger)
      elsif content_type.to_s.downcase.include?('xml') || content_type.to_s.downcase.include?('html')
        @body_obj = parse_xml(body, logger)
      end

      @body_obj
    end

    def body_os=
      @body_os = JSON.parse(body_obj.to_json, object_class: OpenStruct)
    end

    def code=
      @code = response.code
    end

    def content_type
      content_type = headers_hash.select { |k,v| k.to_s.downcase == 'content_type' }

      return nil if content_type.empty?

      content_type[:content_type]
    end

    def headers=
      @headers = {}
      response.to_hash.each do |key, value|
        @headers[key] = value.flatten[0].to_s
      end
    end

    def headers_hash=
      @headers_hash = NetHTTP::Core::Utilities.convert_hash_keys(
        object: headers,
        format: 'snake',
        type: 'symbol'
      )
    end

    def headers_os=
      @headers_os = JSON.parse(headers_hash.to_json, object_class: OpenStruct)
    end

    def response=(response)
      @response = response
    end

    def parse_json(body, logger)
      begin
        NetHTTP::Core::Utilities.json_2_hash(body, 'symbol', logger)
      rescue JSON::ParserError => err
        logger.debug(err)
        return {}
      end
    end

    def parse_xml(body, logger)
      begin
        NetHTTP::Core::Utilities.xml_2_hash(body, 'symbol', logger)
      rescue Nokogiri::XML::SyntaxError => err
        logger.debug(err)
        return {}
      end
    end

    def valid_json?
      NetHTTP::Core::Utilities.valid_json?(body, logger)
    end

    def valid_xml?
      NetHTTP::Core::Utilities.valid_xml?(body, logger)
    end

    def valid_html?
      NetHTTP::Core::Utilities.valid_html?(body, logger)
    end

    private :logger,
            :response

    def logger=(logger = nil)
      @logger = Core.get_logger(logger)
    end

    def log_response
      logger.debug('Response Code => ' + code)
      logger.debug('Response Headers => ')
      logger.debug(headers)
      logger.debug('Response Body => ')
      logger.debug(body)
    end
  end
end
