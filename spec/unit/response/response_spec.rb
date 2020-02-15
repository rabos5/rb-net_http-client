# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'NetHTTP::Response' do
  it 'rescues body_obj= JSON::ParserError' do
    # response = NetHTTP::Response.new(
    #   response: 
    # )
  end

  it 'rescues body_obj= XML Nokogiri::XML::SyntaxError' do

  end

  it 'rescues body_obj= HTML Nokogiri::XML::SyntaxError' do

  end

  private

  def invalid_json_body
    '''

    '''
  end

  def invalid_xml_body
    '''

    '''
  end

  def invalid_html_body
    '''

    '''
  end
end
