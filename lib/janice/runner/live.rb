require 'janice/model/exercise'
require 'janice/model/verification-set'
require 'janice/model/inspection'
require 'janice/events'

module Janice
  module Runner
    class Live
      attr_accessor :registry

      def initialize
        @listeners = []
      end

      def add_listener(listener)
        @listeners << listener
      end

      def send_event(event)
        @listeners.each do |listener|
          event.deliver(listener)
        end
      end

      class LiveValuesRegistry
        attr_reader :subject_registry

        def initialize(subject_registry)
          @subject_registry = subject_registry
          @value_cache = Hash.new do |h,k|
            h[k] = construct_value(k)
          end
          @value_cache[subject_registry.root_void] = nil
        end

        def construct_value(subject)
          producer = subject.consequent_of.first
          producer.action.call(value_for_subject(producer.antecedent), self)
        end

        def value_for_name(name)
          value_for_subject(subject_registry[name])
        end
        alias [] value_for_name

        def value_for_subject(subject)
          @value_cache[subject]
        end
      end

      def build_exercises_list
        exercise_set = {}
        open_list = registry.root_void.antecedent_of

        until open_list.empty? do
          exercise = open_list.pop
          exercise_set[exercise] = true
          exercise.consequent.antecedent_of.each do |new|
            open_list << new unless exercise_set.has_key?(new)
          end
        end

        exercise_set.keys
      end

      def run_verifications(subject, value, list)
        list.each do |item|
          case item
          when VerificationSet
            run_verifications(subject, value, item.all)
          when Inspection
            run_verifications(subject, item.inspect[value], item.all)
          when Verification
            send_event(Events::Verify.new(subject, value, item))
            if item.match?(value)
              send_event(Events::Accept.new(subject, value, item))
            else
              send_event(Events::Reject.new(subject, value, item))
            end
          else
            send_event(Events::UnknownVerifier.new(item))
          end
        end
      end

      def start
        exercises = build_exercises_list

        send_event(Events::ExerciseListBuilt.new(exercises))

        live = LiveValuesRegistry.new(registry)

        send_event(Events::StartRun.new(registry))

        exercises.each do |exercise|
          subject = exercise.consequent
          if subject.has_verifications?
            send_event(Events::VerifyingSubject.new(subject))
            value = live.value_for_subject(subject)
            run_verifications(subject, value, subject.verification_sets)
          end
        end

        send_event(Events::FinishRun.new(registry))
      end
    end
  end
end
