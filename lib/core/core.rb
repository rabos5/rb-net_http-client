# frozen_string_literal: true

require 'logger'

module NetHTTP
  class Core
    def self.get_logger(logger = nil)
      return logger if logger.class == Logger

      if logger.nil? || logger.to_s.empty?
        logger = Logger.new(STDOUT)
        logger.level = Logger::INFO
      end

      logger
    end

    def self.schema_validation(opts, schema)
      results = schema.call(opts)
      if results.success?
        return nil
      else
        return results.errors.to_h
      end
    end
  end
end
