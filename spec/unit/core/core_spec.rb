# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'NetHTTP::Core' do
  it 'successful schema_validation' do
    logger = NetHTTP::Core.get_logger

    results = NetHTTP::Core.schema_validation(
      {
        uri: 'https://www.google.com'
      },
      NetHTTP::Client::Schema
    )

    expect(results).to eq(nil)
  end

  # it 'failed schema_validation' do
  #   logger = NetHTTP::Core.get_logger

  #   expect {
  #     NetHTTP::Core.schema_validation(
  #       {
  #         uri: nil
  #       },
  #       NetHTTP::Client::Schema
  #     )
  #   }.to raise_error(NetHTTP::Client::SchemaError)
  # end

  it 'failed schema_validation -> invalid schema' do
    logger = NetHTTP::Core.get_logger

    expect {
      NetHTTP::Core.schema_validation(
        {
          uri: 'https://www.google.com'
        },
        'Invalid::Schema'
      )
    }.to raise_error(NoMethodError, "undefined method `call' for \"Invalid::Schema\":String")
  end
end
