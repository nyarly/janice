require 'janice/model/subject'

module Janice
  class SubjectRegistry
    def initialize
      @subjects = Hash.new do |h,k|
        h[k] = Subject.new
      end
    end

    def [](name)
      @subjects[name]
    end

    def root_void
      @root_void ||= Subject.new
    end
  end
end
