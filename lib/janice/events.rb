module Janice
  class Event

  end

  module Events
    class Verification < Event
      attr_accessor :verification

      def initialize(verification)
        @verification = verification
      end
    end

    class Accept < Verification
      def deliver(listener)
        listener.verification_accept(self)
      end
    end

    class Reject < Verification
      def deliver(listener)
        listener.verification_reject(self)
      end
    end

    class UnknownVerifier < Event
      def initialize(unknown)
        @unknown = unknown
      end

      def deliver(listener)
        listener.unknown_verifier(self)
      end
    end
  end
end
