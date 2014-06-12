module Janice
  class Event
    def self.listen_for(method)
      Events::ListenerMethods.class_eval do
        define_method(method){|event| }
      end

      define_method(:deliver) do |listener|
        listener.send(method, self)
      end
    end
  end

  module Events
    module ListenerMethods
    end

    class Running < Event
      attr_accessor :registry

      def initialize(registry)
        @registry = registry
      end
    end

    class StartRun < Running
      listen_for :start_run
    end

    class FinishRun < Running
      listen_for :finish_run
    end

    class ExerciseListBuilt < Event
      def initialize(list)
        @exercise_list = list
      end

      listen_for :exercise_list_built
    end

    class VerifyingSubject < Event
      attr_reader :subject

      def initialize(subject)
        @subject = subject
      end

      listen_for :verifying_subject
    end

    class Verification < Event
      attr_accessor :subject, :value, :verification

      def initialize(subject, value, verification)
        @subject = subject
        @value = value
        @verification = verification
      end
    end

    class Verify < Verification
      listen_for :verification
    end

    class Accept < Verification
      listen_for :verification_accept
    end

    class Reject < Verification
      listen_for :verification_reject
    end

    class UnknownVerifier < Event
      def initialize(unknown)
        @unknown = unknown
      end

      listen_for :unknown_verifier
    end
  end
end
