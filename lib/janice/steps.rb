module Janice
  class MethodCall
    def initialize(name, *args, &block)
      @name = name
      @args = args
      @block = block
    end

    def apply(target)
      target.__send__(@name, *@args, &@block)
    end
  end
end
