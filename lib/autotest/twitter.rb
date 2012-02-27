require 'rubygems'
require 'autotest'
require 'twitter'

require 'autotest/twitter/version'
require 'autotest/twitter/config'
require 'autotest/twitter/result'

class Autotest
  module Twitter
    extend self

    def update(vars)
      vars.update(:label => config.label || File.basename(Dir.pwd)) unless vars.key?(:label)

      @twitter ||= ::Twitter.new(
        :consumer_key       => config.consumer_key,
        :consumer_secret    => config.consumer_secret,
        :oauth_token        => config.oauth_token,
        :oauth_token_secret => config.oauth_token_secret
      )

      result = [:missing, :error, :failed, :pending].find {|r| vars.key?(r) } || :passed

      if config.image_dir
        path = File.join(config.image_dir, "#{result}.png")

        if File.exists?(path)
          print 'Icon updating ...'
          user = @twitter.update_profile_image(File.new(path))
          puts " :profile_image_url => #{user['profile_image_url']}"
        end
      end

      message = config.pick_message(result) or raise "Not found the message associated with #{result}"

      status = message.gsub(/\$[a-zA-Z_]\w*/) do |m|
        name = m[1..-1]
        vars[name.to_sym] or raise "Variable is missing: #{name}"
      end

      @twitter.update(status)
    rescue => e
      puts "#{e.class}: #{e.message}"
    end

    def with_test_unit(result)
      vars = {:all => result.get('test-assertion').to_i, :test => result.get('test')}
      vars[:error]  = result.get('test-error').to_i  if result.has?('test-error')
      vars[:failed] = result.get('test-failed').to_i if result.has?('test-failed')
      vars
    end

    def with_rspec(result)
      vars = {:all => result.get('example').to_i}
      vars[:failed]  = result['example-failed'].to_i  if result.has?('example-failed')
      vars[:pending] = result['example-pending'].to_i if result.has?('example-pending')
      vars
    end
  end

  add_hook :updated do
    @ran = false
    false
  end

  add_hook :run_command do
    print "\n" * 2 + '-' * 80 + "\n" * 2
    false
  end

  add_hook :ran_command do |autotest|
    unless @ran
      result = Twitter::Result.new(autotest)

      if result.exists?
        case result.framework
        when 'test-unit'
          vars = Twitter.with_test_unit(result)
          Twitter.update(vars)
        when 'rspec'
          vars = Twitter.with_rspec(result)
          Twitter.update(vars)
        end
      else
        Twitter.update(:missing => true)
      end

      @ran = true
    end

    false
  end
end
