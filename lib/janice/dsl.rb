require 'janice/model'
require 'janice/subject-registry'

module Janice
  def self.context
    @context ||= Context.new
  end

  def self.explain(&block)
    builder = Builder.new(context)
    builder.instance_exec(&block)
    context
  end

  class Context
    attr_accessor :registry

    def initialize
      @registry = SubjectRegistry.new
    end
  end

  class Builder
    attr_accessor :context

    def initialize(context)
      @context = context
      @current_subject = nil
    end

    def registry
      context.registry
    end

    def setup(name, &block)
      exercise = Exercise.new
      exercise.antecedent = registry.root_void
      exercise.action(&block)
      exercise.consequent = registry[name]
      raise DescriptionError, "invalid setup: #{exercise.inspect}" unless exercise.valid?
      @current_subject = exercise.consequent
      exercise
    end

    def exercise(name, &block)
      exercise = Exercise.new
      exercise.antecedent = @current_subject
      exercise.action(&block)
      exercise.consequent = registry[name]
      raise DescriptionError, "invalid exercise: #{exercise.inspect}" unless exercise.valid?
      @current_subject = exercise.consequent
      exercise
    end

    def from(name)
      @current_subject = registry[name]
    end

    def verify(&block)
      builder = VerificationBuilder.new(context, VerificationSet.new)
      builder.instance_exec(&block)
      @current_subject.verifier(builder.set)
      builder.set
    end
  end

  class InspectionBridge
    attr_reader :context, :inspector
    def initialize(context, inspector)
      @context = context
      @inspector = inspector
    end

    def to(&block)
      builder = VerificationBuilder.new(context, inspector)
      builder.instance_exec(&block)
      builder.set
    end
  end

  class VerificationBuilder
    attr_reader :context, :set
    def initialize(context, set)
      @context = context
      @set = set
    end

    def also(&block)
      inspector = Inspection.new
      inspector.inspect(&block)
      set.add(inspector)

      return InspectionBridge.new(context, inspector)
    end

    include Verification::SetDSL
  end
end
