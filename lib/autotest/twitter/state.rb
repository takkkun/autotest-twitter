module Autotest
  module Twitter
    class State
      def initialize
        @ran_tests = false
        @ran_features = false
      end

      def clear
        @ran_tests = false
        @ran_features = false
      end

      def ran_tests
        @ran_tests = true
      end

      def ran_tests?
        if block_given?
          unless @ran_tests
            yield
            ran_tests
          end
        else
          @ran_tests
        end
      end

      def ran_features
        @ran_features = true
      end

      def ran_features?
        if block_given?
          unless @ran_features
            yield
            ran_features
          end
        else
          @ran_features
        end
      end
    end
  end
end
