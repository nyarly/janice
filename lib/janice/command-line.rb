require 'janice/dsl'
require 'janice/runner/live'
require 'janice/event-listener'

module Janice
  class CommandLine
    attr_reader :argv

    def initialize(argv)
      @argv = argv
    end

    def test_files
      argv
    end

    def run
      test_files.each do |file|
        require file
      end

      runner = Runner::Live.new
      runner.registry = Janice.context.registry
      runner.add_listener DotsReporter.new($stdout)

      runner.start
    end
  end
end
