module Janice
  class Verification
    module SetDSL
      def eql(arg)
        set.add(Verification::Eql.new(arg))
      end
    end

    class Eql < Verification
      def initialize(expected)
        @expected = expected
      end

      def match?(actual)
        return @expected.eql?(actual)
      end
    end

    module SetDSL
      def adhoc(&block)
        set.add(Verification::Adhoc.new(&block))
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
