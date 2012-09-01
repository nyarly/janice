require 'janice'
require 'janice/runner/mocked'

riff = Janice::Riff.new

make_string = Janice::Change.new
make_string.start_at = ["String"]
make_string.add_step Janice::MethodCall.new(:new, "A string")

riff.add_change(make_string)

length_is_eight = Janice::Expectation.new("Length", "8")
length_is_eight.add_step Janice::MethodCall.new(:length)
length_is_eight.check = Janice::MethodCall.new(:==, 8)

riff.add_expectation length_is_eight

runner = Janice::MockedRunner.new(riff)
puts "Should fail: length of 'A long string' in not 8"
puts runner.go

#Real POC: array sort works as intended with class that implements #<=>
