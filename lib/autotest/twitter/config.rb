class Autotest
  module Twitter
    def self.config
      @@config ||= Config.new
    end

    def self.configure
      yield config if block_given?
    end

    class Config
      attr_reader :consumer_key, :consumer_secret, :oauth_token, :oauth_token_secret, :label, :image_dir
    end
  end
end
