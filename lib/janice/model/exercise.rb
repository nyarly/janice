require 'janice/model/subject'

module Janice
  class DescriptionError < ::Exception
  end

  class Exercise
    attr_reader :antecedent, :consequent

    def initialize

    end

    def antecedent=(subject)
      raise DescriptionError, "#{self.inspect} - antecedent redefined" unless @antecedent.nil?
      raise DescriptionError, "#{self.inspect} - attempted to set non-Subject antecedent" unless subject.is_a? Subject
      subject.consumer(self)
      @antecedent = subject
    end

    def consequent=(subject)
      raise DescriptionError, "#{self.inspect} - consequent redefined" unless @consequent.nil?
      raise DescriptionError, "#{self.inspect} - attempted to set non-Subject conseqent" unless subject.is_a? Subject
      subject.producer(self)
      @consequent = subject
    end

    def action(&block)
      if block.nil?
        @action
      else
        @action = block
      end
    end

    def valid?
      return (@action != nil && @antecedent != nil && @consequent != nil)
    end
  end
end
