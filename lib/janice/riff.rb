require 'janice/dependency'

module Janice
  class Riff
    def initialize
      @change = nil
      @changes = []
      @dependencies = []
      @expectations = []
    end

    attr_accessor :change, :changes, :dependencies, :expectations

    def add_dependency(riff)
      @dependencies << Dependency.new(riff)
    end

    def add_trigger(riff)
      @dependencies << Trigger.new(riff)
    end

    def add_expectation(expectation)
      @expectations << expectation
    end

    def add_change(change)
      if @changes.empty?
        @change = change
      end
      @changes << change
    end
  end
end
