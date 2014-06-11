module Janice
  class EventListener
    def verification_accept(event)

    end

    def verification_reject(event)

    end
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
  end
end
