module Janice
  class Inspection
    def initialize
      @verifications = []
    end

    def add(verification)
      @verifications << verification
    end

    def all
      @verifications
    end

    def inspect(&block)
      if block.nil?
        @block
      else
        @block = block
      end
    end
  end
end
