module Janice
  class Subject
    attr_accessor :example

    def initialize
      @antecedent_set = {}
      @consequent_set = {}
      @verifiers = {}
    end

    def verification_sets
      @verifiers.keys
    end

    def has_verifications?
      !@verifiers.empty?
    end

    def antecedent_of
      @antecedent_set.keys
    end

    def consequent_of
      @consequent_set.keys
    end

    def verifier(set)
      @verifiers[set] = true
    end

    def consumer(exercise)
      @antecedent_set[exercise] = true
    end

    def producer(exercise)
      @consequent_set[exercise] = true
    end
  end
end
