# frozen_string_literal: true

require 'dry-validation'

module NetHTTP
  class Request
    class Schema < Dry::Validation::Contract
      schema do
        required(:method).value(:string).filled
        optional(:headers).value(:hash)
        optional(:body)
        optional(:query).filled
        optional(:uri).value(:string).filled
        optional(:url).value(:string).filled
        optional(:path).value(:string).filled
      end

      rule(:uri, :url, :path) do
        key.failure('uri, url, & path cannot all be nil') if (values[:uri].nil? && values[:url].nil? && values[:path].nil?)
      end
    end

    class SchemaError < StandardError
      def initialize(msg)
        super(msg)
      end
    end
  end
end
