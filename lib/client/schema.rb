# frozen_string_literal: true

require 'dry-validation'

module NetHTTP
  class Client
    class Schema < Dry::Validation::Contract
      schema do
        optional(:ca_file).value(:string).filled
        optional(:host).value(:string)
        optional(:logger).filled
        optional(:open_timeout).value(:integer).filled
        optional(:path).value(:string)
        optional(:port).value(:integer)
        optional(:pkcs12_file).value(:string).filled
        optional(:pkcs12_passphrase).value(:string).filled
        optional(:proxy_uri_host).value(:string)
        optional(:proxy_uri_path).value(:string)
        optional(:proxy_uri_port).value(:integer)
        optional(:proxy_uri_scheme).value(:string)
        optional(:proxy_uri).value(:string).filled
        optional(:proxy_url).value(:string).filled
        optional(:query).value(:string).filled
        optional(:read_timeout).value(:integer).filled
        optional(:scheme).value(:string)
        optional(:ssl_path).value(:string).filled
        optional(:uri).value(:string)
        optional(:url).value(:string)
        optional(:use_ssl)
        optional(:verify_mode).filled
      end

      rule(:uri, :url, :host) do
        key.failure('uri, url, & host cannot all be nil') if (values[:uri].nil? && values[:url].nil? && values[:host].nil?)
      end

      rule(:uri, :url, :scheme, :port) do
        key.failure('if uri and url are nil, scheme or port cannot be nil') if (values[:uri].nil? && values[:url].nil? && (values[:scheme].nil? || values[:port].nil?))
      end

      rule(:use_ssl) do
        key.failure('use_ssl must be either true or false') if (!values[:use_ssl].nil? && values[:use_ssl].class != (FalseClass || TrueClass))
      end
    end

    class SchemaError < StandardError
      def initialize(msg)
        super(msg)
      end
    end
  end
end
