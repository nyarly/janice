require 'janice/runner/live'
require 'janice/subject-registry'
require 'janice/model/verification'
require 'janice/event-listener'
require 'janice/dsl'

describe Janice::Runner::Live do
  let :listener do
    instance_double("Janice::EventListener")
  end

  let :runner do
    Janice::Runner::Live.new.tap do |runner|
      runner.registry = registry
      runner.add_listener(listener)
    end
  end

  let :context do
    Janice::Context.new
  end

  let :registry do
    context.registry
  end

  before do
    Janice::Builder.new(context).instance_eval do
      setup("number one"){ 1 }

      setup("empty array"){ Array.new }
      exercise "add an item" do |array, registry|
        array << registry["number one"]
      end
      verify do
        adhoc{|arr| arr.length == 1}
        eql("red herring")

        also{|arr| arr.length}.to do
          eql(1)
        end
      end

      from "empty array"
      exercise "add two items" do |array|
        array += [3, 4]
      end
      verify do
        also{|arr| arr.length}.to do
          eql(2)
        end
      end
    end
  end

  it "should build a complete set of exercises" do
    expect(runner.build_exercises_list.length).to eq(4)
  end

  it "should generate a verification pass event" do
    #verification accept
    #verification reject
    expect(listener).to receive(:exercise_list_built).once
    expect(listener).to receive(:start_run).once
    allow(listener).to receive(:verifying_subject)
    allow(listener).to receive(:verification)
    expect(listener).to receive(:verification_accept).with(match(be_a(Janice::Event))).exactly(3).times
    expect(listener).to receive(:verification_reject).with(match(be_a(Janice::Event))).once
    expect(listener).to receive(:finish_run).once
    runner.start
  end
end
