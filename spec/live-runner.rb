require 'janice/runner/live'
require 'janice/subject-registry'
require 'janice/model/verification'
require 'janice/event-listener'

describe Janice::Runner::Live do
  let :registry do
    Janice::SubjectRegistry.new
  end

  let :listener do
    Janice::DotsReporter.new(StringIO.new)
  end

  let :runner do
    Janice::Runner::Live.new.tap do |runner|
      runner.registry = registry
      runner.add_listener(listener)
    end
  end

  before :each do
    Janice::Exercise.new.tap do |empty_array|
      empty_array.antecedent = registry.root_void
      empty_array.consequent = registry["empty array"]
      empty_array.action{ Array.new }
    end

    Janice::Exercise.new.tap do |one_item|
      one_item.antecedent = registry["empty array"]
      one_item.consequent = registry["one item array"]
      one_item.action do |subject, registry|
        subject << registry["number one"]
      end
    end

    Janice::Exercise.new.tap do |one|
      one.antecedent = registry.root_void
      one.consequent = registry["number one"]
      one.action{ 1 }
    end

    Janice::VerificationSet.new.tap do |has_one|
      registry["one item array"].verifier(has_one)
      has_one.add(Janice::Verification::Adhoc.new do |subject|
        subject.length == 1
      end)

      has_one.add(Janice::Verification::Eql.new("a herring"))

      has_one.add(Janice::Inspection.new.tap do |length|
        length.inspect{|subject| subject.length}
        length.add(Janice::Verification::Eql.new(1))
      end)
    end
  end

  it "should build a complete set of exercises" do
    expect(runner.build_exercises_list.length).to eq(3)
  end

  it "should generate a verification pass event" do
    #verification accept
    #verification reject
    expect(listener).to receive(:verification_accept).with(match(be_a(Janice::Event))).twice
    expect(listener).to receive(:verification_reject).with(match(be_a(Janice::Event))).once
    runner.start
  end
end
