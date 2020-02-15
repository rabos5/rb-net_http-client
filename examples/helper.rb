# frozen_string_literal: true

require 'dotenv/load'
require 'logger'
require_relative 'opt_parser'
require_relative '../lib/rb-net_http-client'

@logger = Logger.new(STDOUT)
@logger.level = Logger::DEBUG

Dotenv.load(@opts[:env_file].to_s) unless @opts[:env_file].nil?
