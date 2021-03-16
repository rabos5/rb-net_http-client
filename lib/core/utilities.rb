# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'nokogiri'
require 'uri'
require 'yaml'

module NetHTTP
  class Core
    class Utilities
      def self.construct_uri(uri = {})
        return nil if uri.empty?
        return nil if uri[:host].to_s.empty?
        return nil if uri[:scheme].to_s.empty? && uri[:port].to_s.empty?

        scheme = uri[:scheme]
        if scheme.to_s.empty?
          case uri[:port]
          when 80, '80'
            scheme = 'http'
          else
            scheme = 'https'
          end
        end

        port = uri[:port]
        if port.to_s.empty?
          case uri[:scheme]
          when 'https'
            port = 443
          when 'http'
            port = 80
          end
        end

        if uri[:user].to_s.empty? || uri[:password].to_s.empty?
          user_pass = nil
        else
          user_pass = "#{uri[:user]}:#{uri[:password]}@"
        end

        scheme = "#{scheme}://"
        host = uri[:host]
        port = ":#{port}"
        path = uri[:path]
        query = parse_query(uri[:query])

        scheme = nil if scheme.to_s.empty?
        port = nil if port.to_s.empty?
        path = nil if uri[:path].to_s.empty?
        query = nil if uri[:query].to_s.empty?

        URI("#{scheme}#{user_pass}#{host}#{port}#{path}#{query}").to_s
      end

      def self.parse_query(query)
        case query
        when String
          query = query[1..-1] if query.start_with?('?')
          URI.encode_www_form_component("?#{query}")
        when Hash
          query = query.map { |k, v| "#{k}=#{v}" }
          query = query.join('&')
          URI.encode_www_form_component("?#{query}")
        else
          nil
        end
      end

      def self.parse_uri(uri)
        return if uri.nil?
        return if uri.to_s.empty?

        scheme = uri.to_s.scan(%r{([a-z][a-z0-9+\-.]*)://}).flatten[0].to_s
        return URI(uri) if scheme.downcase == 'http'
        return URI(uri) if scheme.downcase == 'https'

        port = uri.to_s.scan(%r{:([0-9]+)}).flatten[0].to_s
        return URI("http://#{uri.to_s.gsub("#{scheme}://", '')}") if port == '80'

        URI("https://#{uri.to_s.gsub("#{scheme}://", '')}")
      end

      # CamelCase to snake_case
      def self.camel_2_snake(key, type = nil)
        key_class = key.class.to_s.downcase
        new_key = key.to_s
                     .tr('::', '/')
                     .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                     .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                     .tr('-', '_')
                     .downcase

        # return the newly formatted key without modifying the type
        if type.nil?
          case key_class
          when 'string'
            return new_key.to_s
          when 'symbol'
            return new_key.to_sym
          end
        end

        # return the newly formatted key in type format requested
        return new_key.to_s if type.to_s.downcase == 'string'
        return new_key.to_sym if type.to_s.downcase == 'symbol'

        nil
      end

      # snake_case to CamelCase
      def self.snake_2_camel(key, type = nil)
        key_class = key.class.to_s.downcase
        new_key = key.to_s.split('_')
        new_key = new_key[0].downcase + new_key[1..-1].map(&:capitalize).join('')

        # return the newly formatted key without modifying the type
        if type.nil?
          case key_class
          when 'string'
            return new_key.to_s
          when 'symbol'
            return new_key.to_sym
          end
        end

        # return the newly formatted key in type format requested
        return new_key.to_s if type.to_s.downcase == 'string'
        return new_key.to_sym if type.to_s.downcase == 'symbol'

        nil
      end

      # convert hash / array / nested object keys to either snake_case or CamelCase
      # format -> 'snake' or 'camel'
      # type -> 'string' or 'symbol'
      def self.convert_hash_keys(opts = {})
        return opts[:object] if opts[:format].nil? && opts[:type].nil?

        case opts[:object]
        when Hash
          new_hash = {}
          opts[:object].each do |key, value|
            value = convert_hash_keys(
              object: value,
              format: opts[:format],
              type: opts[:type]
            )
            case opts[:format].downcase
            when 'snake'
              new_key = camel_2_snake(key, opts[:type])
            when 'camel'
              new_key = snake_2_camel(key, opts[:type])
            end
            new_hash[new_key] = value
          end
          return new_hash
        when Array
          return opts[:object].map { |value| convert_hash_keys(object: value, format: opts[:format], type: opts[:type]) }
        end

        opts[:object]
      end

      # Recursive function to remove nil and empty values (including [] and {} from Array or Hash nested objects.
      def self.scrub_obj(obj)
        case obj
        when Array
          return obj.map { |item| scrub_obj(item) }
        when Hash
          new_hash = {}
          obj.compact.each do |key, value|
            new_hash[key] = scrub_obj(value) unless empty_or_blank?(value)
          end

          return new_hash
        end

        obj
      end

      # helper method to deal with objects that will otherwise fail in scrub_obj() above
      def self.empty_or_blank?(obj)
        return true if obj.nil?
        return false if obj.is_a?(TrueClass)
        return false if obj.is_a?(FalseClass)

        begin
          return true if obj.empty?
        rescue NoMethodError => err
        end

        begin
          return true if obj.blank?
        rescue NoMethodError => err
        end

        false
      end

      # Convert JSON doc to a Ruby Hash.
      def self.json_2_hash(json_doc, type = 'symbol', logger = nil)
        msg = "Invalid 'type' => #{type}.  Use either 'string' or 'symbol' (default)."
        unless ['string', 'symbol'].include?(type.downcase)
          if logger.nil? || logger.to_s.empty?
            puts msg
          else
            logger.debug(msg)
          end
          raise msg
        end

        json_doc = JSON.parse(json_doc) if json_doc.class == String

        begin
          convert_hash_keys(
            object: json_doc,
            format: 'snake',
            type: type.downcase
          )
        rescue RuntimeError => err
          raise err
        end
      end

      # Convert XML doc to a Ruby Hash.
      def self.xml_2_hash(xml_doc, type = 'symbol', logger = nil)
        msg = "Invalid 'type' => #{type}.  Use either 'string' or 'symbol' (default)."
        unless ['string', 'symbol'].include?(type.downcase)
          if logger.nil? || logger.to_s.empty?
            puts msg
          else
            logger.debug(msg)
          end
          raise msg
        end

        xml_doc = Hash.from_xml(format_xml_doc(xml_doc))
        begin
          convert_hash_keys(
            object: xml_doc,
            format: 'snake',
            type: type.downcase
          )
        rescue RuntimeError => err
          raise err
        end
      end

      def self.format_xml_doc(xml_doc)
        case xml_doc
        when String
          formatted_xml_doc = Nokogiri::XML(xml_doc) { |c| c.options = Nokogiri::XML::ParseOptions::STRICT }
          formatted_xml_doc = formatted_xml_doc.remove_namespaces!.to_s
        when Nokogiri::XML::Document
          formatted_xml_doc = xml_doc.remove_namespaces!.to_s
        else
          raise "Unrecognized 'xml_doc' class => '#{xml_doc.class}'"
        end

        formatted_xml_doc
      end

      # Convert YAML doc to a Ruby Hash.
      def self.yaml_2_hash(yaml_doc, type = 'symbol', logger = nil)
        msg = "Invalid 'type' => #{type}.  Use either 'string' or 'symbol' (default)."
        unless ['string', 'symbol'].include?(type.downcase)
          if logger.nil? || logger.to_s.empty?
            puts msg
          else
            logger.debug(msg)
          end
          raise msg
        end

        case yaml
        when Hash
          yaml_doc = yaml_doc.to_hash
        when String
          yaml_doc = YAML.safe_load(yaml_doc).to_hash
        end

        begin
          convert_hash_keys(
            object: yaml_doc,
            format: 'snake',
            type: type.downcase
          )
        rescue RuntimeError => err
          raise err
        end
      end

      def self.valid_json?(json_doc, logger = nil)
        begin
          return false if json_doc.nil?
          return false if json_doc.empty?

          JSON.parse(json_doc)
        rescue JSON::ParserError => err
          if logger.nil? || logger.to_s.empty?
            puts 'WARNING - JSON syntax / parsing errors detected:'
            puts err
          else
            logger.debug('WARNING - JSON syntax / parsing errors detected:')
            logger.debug(err)
          end
          return false
        end

        true
      end

      def self.valid_xml?(xml_doc, logger = nil)
        begin
          return false if xml_doc.nil?
          return false if xml_doc.empty?

          begin
            parse_errors = Nokogiri::XML(xml_doc).errors { |c| c.options = Nokogiri::XML::ParseOptions::STRICT }
            Nokogiri::XML(xml_doc) { |c| c.options = Nokogiri::XML::ParseOptions::STRICT }
          rescue Nokogiri::XML::SyntaxError
            if logger.nil? || logger.to_s.empty?
              puts 'WARNING - XML syntax / parsing errors detected:'
              puts parse_errors
            else
              logger.debug('WARNING - XML parsing / syntax errors detected:')
              logger.debug(parse_errors)
            end
            return false
          end
        end

        true
      end

      def self.valid_html?(html_doc, logger = nil)
        begin
          return false if html_doc.nil?
          return false if html_doc.empty?
          return false unless html_doc.include?('<html>')
          return false unless html_doc.include?('</html>')
          return false unless html_doc.include?('<body>')
          return false unless html_doc.include?('</body>')
          return false unless Nokogiri::HTML(html_doc).errors.empty?
          return false unless Nokogiri::XML(html_doc).errors.empty?

          begin
            # parse_errors = Nokogiri::HTML.parse(html_doc).validate
            parse_errors = Nokogiri::XML(html_doc).errors { |c| c.options = Nokogiri::XML::ParseOptions::STRICT }
            Nokogiri::XML(html_doc) { |c| c.options = Nokogiri::XML::ParseOptions::STRICT }
          rescue Nokogiri::XML::SyntaxError
            if logger.nil? || logger.to_s.empty?
              puts 'WARNING - HTML syntax / parsing errors detected:'
              puts parse_errors
            else
              logger.debug('WARNING - HTML syntax / parsing errors detected:')
              logger.debug(parse_errors)
            end
            return true
          end
        rescue RuntimeError => err
          raise err
        end

        true
      end
    end
  end
end
