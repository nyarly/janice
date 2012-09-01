require 'janice/steps'

module Janice
  class Change
    def initialize()
      @start_at = ["Kernel"]
      @steps = []
    end

    attr_accessor :start_at

    def add_step(step)
      @steps << step
    end

    def execute
      result = @start_at.inject(Object) do |mod, const|
        mod.const_get(const)
      end

      @steps.inject(result) do |result, step|
        step.apply(result)
      end
    end
  end
end
