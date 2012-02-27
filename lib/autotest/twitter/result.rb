module Autotest
  module Twitter
    class Result
      def initialize(autotest)
        @numbers = {}
        lines = autotest.results.map {|s| s.gsub(/(\e.*?m|\n)/, '') }
        lines.reject! {|line| !line.match(/\d+\s+(example|test|scenario|step)s?/) }

        lines.each do |line|
          prefix = nil
          line.scan(/([1-9]\d*)\s(\w+)/) do |number, kind|
            kind.sub!(/s$/, '')
            kind.sub!(/failure/, 'failed')

            if prefix
              @numbers["#{prefix}-#{kind}"] = number.to_i
            else
              @numbers[kind] = number.to_i
              prefix = kind
            end
          end
        end
      end

      def framework
        case
        when @numbers['test']     then 'test-unit'
        when @numbers['example']  then 'rspec'
        when @numbers['scenario'] then 'cucumber'
        end
      end

      def exists?
        !@numbers.empty?
      end

      def has?(kind)
        @numbers.has_key?(kind)
      end

      def [](kind)
        @numbers[kind]
      end

      def get(kind)
        "#{@numbers[kind]} #{kind.sub(/^.*-/, '')}#{'s' if @numbers[kind] != 1 && !kind.match(/(ed|ing)$/)}" if @numbers[kind]
      end
    end
  end
end
