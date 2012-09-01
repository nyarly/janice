module Janice
  class Expectation
    def initialize(examined, expected)
      @examined = examined
      @expected = expected
      @check = nil
      @steps = []
    end

    attr_accessor :check

    def add_step(step)
      @steps << step
    end

    def confirm(target)
      target = @steps.inject(target) do |target, step|
        step.apply(target)
      end

      if check.apply(target)
        return :passed
      else
        raise "Expectation failed: #@examined of target was #{target.inspect} not #@expected"
      end
    end
  end
end
