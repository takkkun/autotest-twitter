require 'oauth'

class Autotest
  module Twitter
    class Client
      def initialize
        yield(self) if block_given?
      end

      attr_accessor :consumer, :access_token, :label, :image_dir

      def client
        @client ||= create_client(consumer, access_token)
      end

      def update(status, icon = nil)
        status = "#{label}: #{status}" unless label.nil? || label.empty?
        client.post('/statuses/update.json', :status => status)
      end

      private

      def create_client(consumer, access_token)
        raise '`consumer` is required'     if consumer.nil?
        raise '`access_token` is required' if access_token.nil?

        raise '`consumer` must be an array'     unless Array === consumer
        raise '`access_token` must be an array' unless Array === access_token

        raise 'The number of elements in `consumer` must be at least two'     if consumer.size < 2
        raise 'The number of elements in `access_token` must be at least two' if access_token.size < 2

        args = consumer + ['https://api.twitter.com/1']
        OAuth::AccessToken.new(OAuth::Consumer.new(*args), *access_token)
      end
    end
  end
end
