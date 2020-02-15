# frozen_string_literal: true

require 'optparse'

# default values
@opts = {
  env_file: nil
}

OptionParser.new do |opts|
  opts.banner = 'Script Helper Opt Parser'

  opts.on('-f', '--env-file ENV_FILE', String, 'Provide a path + file name to load environment variables from.') do |env_file|
    @opts[:env_file] = env_file
  end
end
