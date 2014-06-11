module Janice
  class Verification
    class Eql < Verification
      def initialize(expected)
        @expected = expected
      end

      def match?(actual)
        return @expected.eql?(actual)
      end
    end

    class Adhoc < Verification
      def initialize(&block)
        @adhoc_block = block
      end

      def match?(actual)
        return @adhoc_block[actual]
      end
    end
  end
end
