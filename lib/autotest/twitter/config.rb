class Autotest
  module Twitter
    def self.config
      @@config ||= Config.new
    end

    def self.configure
      yield config if block_given?
    end

    class Config
      def initialize
        @missing_messages = ['$label: Test is missing']
        @error_messages   = ['']
        @failed_messages  = ['$label: $failed of $all examples failed']
        @pending_messages = ['$label: $pending of $all examples failed']
        @passed_messages  = ['$label: $all examples passed']
      end

      attr_accessor *%w(
        consumer_key
        consumer_secret
        oauth_token
        oauth_token_secret
        label
        image_dir
        missing_messages
        error_messages
        failed_messages
        pending_messages
        passed_messages
      )

      def pick_message(result)
        messages = {
          :missing => missing_messages,
          :error   => error_messages,
          :failed  => failed_messages,
          :pending => pending_messages,
          :passed  => passed_messages
        }[result]

        Array === messages ? messages.sample : messages
      end
    end
  end
end
