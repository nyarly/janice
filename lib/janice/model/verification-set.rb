module Janice
  class VerificationSet
    attr_reader :all

    def initialize
      @all = []
    end

    def add(verification)
      @all << verification
    end
  end
end
