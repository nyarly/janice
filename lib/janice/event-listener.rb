module Janice
  class EventListener
    include Events::ListenerMethods
  end

  class DotsReporter < EventListener
    attr_reader :output

    def initialize(output)
      @output = output
    end

    def verification_accept(event)
      output.print(".")
    end

    def verification_reject(event)
      output.print("F")
    end

    def finish_run(event)
      output.puts
    end
  end
end
