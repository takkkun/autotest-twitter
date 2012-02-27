class Autotest
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

      %w(tests features).each do |target|
        define_method "ran_#{target}" do
          instance_variable_set("@#{target}", true)
        end

        define_method "ran_#{target}?" do
          ran = instance_variable_get("@#{target}")

          if block_given?
            unless ran
              yield
              __send__("ran_#{target}")
            end
          else
            ran
          end
        end
      end
    end
  end
end
