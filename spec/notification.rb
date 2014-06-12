require 'janice/events'

describe Janice::Events do
  let :listener do
    double("listener")
  end

  let :subject do
    double("Subject")
  end

  let :value do
    1
  end

  let :verification do
    Janice::Verification::Eql.new("yes")
  end

  describe Janice::Events::Accept do
    let :event do
      Janice::Events::Accept.new(subject, value, verification)
    end

    it "should deliver to #verification_accept on listener" do
      expect(listener).to receive(:verification_accept).with(event)
      event.deliver(listener)
    end

    it "should expose verification" do
      expect(event.verification).to eq(verification)
    end
  end

  describe Janice::Events::Reject do
    let :event do
      Janice::Events::Reject.new(subject, value, verification)
    end

    it "should deliver to #verification_reject on listener" do
      expect(listener).to receive(:verification_reject).with(event)
      event.deliver(listener)
    end

    it "should expose verification" do
      expect(event.verification).to eq(verification)
    end
  end
end
