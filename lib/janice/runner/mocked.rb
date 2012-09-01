module Janice
  class MockedRunner # < Runner
    def initialize(riff)
      @riff = riff
    end

    def go
      setup_deps
      check_assertions(run_change)
      return "all passed"
    end

    def setup_deps
      @riff.dependencies.each do |dep|
        dep.mock
      end
    end

    def run_change
      @riff.change.execute
    end

    def check_assertions(change_result)
      p change_result
      @riff.expectations.each do |expectation|
        p expectation
        expectation.confirm(change_result)
      end
    end
  end
end
