require 'rubygems'
require 'autotest'

require 'autotest/twitter/version'
require 'autotest/twitter/client'
require 'autotest/twitter/state'
require 'autotest/twitter/result'

class Autotest
  module Twitter
    extend self

    def configure
      @client = Client.new
      yield(@client) if block_given?
    end

    def update(status, icon = nil)
      @client.update(status, icon)
    end

    def with_test_unit(result)
      if result.has?('test-error')
        ["#{result.get('test-error')} in #{result.get('test')}", :error]
      elsif result.has?('test-failed')
        ["#{result['test-failed']} of #{result.get('test-assertion')} in #{result.get('test')} failed", :failed]
      else
        ["#{result.get('test-assertion')} in #{result.get('test')}", :passed]
      end
    end

    def with_rspec(result)
      if result.has?('example-failed')
        ["#{result['example-failed']} of #{result.get('example')} failed", :failed]
      elsif result.has?('example-pending')
        ["#{result['example-pending']} of #{result.get('example')} pending", :pending]
      else
        ["#{result.get('example')}", :passed]
      end
    end

    def with_cucumber(result)
      explanation = []

      if result.has?('scenario-undefined') || result.has?('step-undefined')
        explanation << "#{result['scenario-undefined']} of #{result.get('scenario')} not defined" if result['scenario-undefined']
        explanation << "#{result['step-undefined']} of #{result.get('step')} not defined" if result['step-undefined']
        ["#{explanation.join("\n")}", :pending]
      elsif result.has?('scenario-failed') || result.has?('step-failed')
        explanation << "#{result['scenario-failed']} of #{result.get('scenario')} failed" if result['scenario-failed']
        explanation << "#{result['step-failed']} of #{result.get('step')} failed" if result['step-failed']
        ["#{explanation.join("\n")}", :failed]
      elsif result.has?('scenario-pending') || result.has?('step-pending')
        explanation << "#{result['scenario-pending']} of #{result.get('scenario')} pending" if result['scenario-pending']
        explanation << "#{result['step-pending']} of #{result.get('step')} pending" if result['step-pending']
        ["#{explanation.join("\n")}", :pending]
      else
        ['', :passed]
      end
    end
  end

  add_hook :initialize do
    @state = Twitter::State.new
    false
  end

  add_hook :updated do
    @state.clear
    false
  end

  add_hook :run_command do
    print "\n" * 2 + '-' * 80 + "\n" * 2
    false
  end

  add_hook :ran_command do |autotest|
    @state.ran_tests? do
      result = Twitter::Result.new(autotest)

      if result.exists?
        case result.framework
        when 'test-unit'
          status, icon = Twitter.with_test_unit(result)
          Twitter.update(status, icon)
        when 'rspec'
          status, icon = Twitter.with_rspec(result)
          Twitter.update(status, icon)
        end
      else
        Twitter.update('Could not run tests', :missing)
      end
    end

    false
  end

  add_hook :ran_features do |autotest|
    @state.ran_features? do
      result = Twitter::Result.new(autotest)

      if result.exists?
        case result.framework
        when 'cucumber'
          status, icon = Twitter.with_cucumber(result)
          Twitter.update(status, icon)
        end
      else
        Twitter.update('Could not run features', :missing)
      end
    end

    false
  end
end
