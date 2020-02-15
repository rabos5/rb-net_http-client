# frozen_string_literal: true

module NetHTTP
  class Client
    def proxy_uri=(opts = {})
      proxy_uri = opts[:proxy_uri] || opts[:proxy_url]

      begin
        if proxy_uri.to_s.empty? == false
          @proxy_uri = Core::Utilities.parse_uri(proxy_uri)
        else
          @proxy_uri = Core::Utilities.parse_uri(
            Core::Utilities.construct_uri(
              scheme: opts[:proxy_uri_scheme],
              user: opts[:proxy_uri_user],
              password: opts[:proxy_uri_password],
              host: opts[:proxy_uri_host],
              port: opts[:proxy_uri_port],
              path: opts[:proxy_uri_path],
              query: opts[:proxy_uri_query]
            )
          )
        end
      rescue RuntimeError => err
        logger.debug(err)
        @proxy_uri = nil
      end
    end

    def uri=(opts = {})
      uri = opts[:uri] || opts[:url]
      begin
        if uri.to_s.empty? == false
          @uri = Core::Utilities.parse_uri(uri)
        else
          @uri = Core::Utilities.parse_uri(
            Core::Utilities.construct_uri(
              scheme: opts[:scheme],
              user: opts[:user],
              password: opts[:password],
              host: opts[:host],
              port: opts[:port],
              path: opts[:path],
              query: opts[:query]
            )
          )
        end
      rescue RuntimeError => err
        logger.debug(err)
        @uri = nil
      end
    end

    def ca_file=(ca_file)
      if ca_file.nil? || ca_file.to_s.empty?
        @ca_file = nil
      elsif ssl_path.nil? || ssl_path.to_s.empty?
        @ca_file = nil
      else
        @ca_file = File.binread(ssl_path + '/' + ca_file)
      end
    end

    def cert=
      if pkcs12.nil? || pkcs12.to_s.empty?
        @cert = nil
      else
        @cert = OpenSSL::X509::Certificate.new(pkcs12.certificate)
      end
    end

    def key=
      if pkcs12.nil? || pkcs12.to_s.empty?
        @key = nil
      else
        @key = OpenSSL::PKey::RSA.new(pkcs12.key)
      end
    end

    def open_timeout=(open_timeout)
      @open_timeout = open_timeout.to_s.to_i
    end

    def pkcs12=
      if ssl_path.nil? || ssl_path.to_s.empty?
        @pkcs12 = nil
      elsif pkcs12_file.nil? || pkcs12_file.to_s.empty?
        @pkcs12 = nil
      elsif pkcs12_passphrase.nil? || pkcs12_passphrase.to_s.empty?
        @pkcs12 = nil
      else
        @pkcs12 = OpenSSL::PKCS12.new(File.binread(ssl_path + '/' + pkcs12_file), pkcs12_passphrase)
      end
    end

    def pkcs12_file=(pkcs12_file)
      if pkcs12_file.nil? || pkcs12_file.to_s.empty?
        @pkcs12_file = nil
      else
        @pkcs12_file = pkcs12_file
      end
    end

    def pkcs12_passphrase=(pkcs12_passphrase)
      if pkcs12_passphrase.nil? || pkcs12_passphrase.to_s.empty?
        @pkcs12_passphrase = nil
      else
        @pkcs12_passphrase = pkcs12_passphrase
      end
    end

    def proxy_from_env=(proxy_from_env)
      if proxy_from_env == true
        @proxy_from_env = true
      else
        @proxy_from_env = false
      end
    end

    def read_timeout=(read_timeout)
      @read_timeout = read_timeout.to_s.to_i
    end

    def ssl_path=(ssl_path)
      if ssl_path.nil? || ssl_path.to_s.empty?
        @ssl_path = nil
      else
        @ssl_path = ssl_path
      end
    end

    def use_ssl=(use_ssl, scheme)
      @use_ssl = true
      case use_ssl
      when false
        @use_ssl = false
      when true
        @use_ssl = true
      else
        case scheme.downcase
        when 'http'
          @use_ssl = false
        when 'https'
          @use_ssl = true
        end
      end
    end

    def verify_mode=(verify_mode)
      if verify_mode.nil? || verify_mode.to_s.empty?
        @verify_mode = OpenSSL::SSL::VERIFY_NONE
      else
        @verify_mode = verify_mode
      end
    end
  end
end
