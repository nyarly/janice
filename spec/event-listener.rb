require 'janice/event-listener'

describe Janice::DotsReporter do
  let :output do
    StringIO.new
  end

  let :formatter do
    Janice::DotsReporter.new(output)
  end

  let :verification do
    double("Verification")
  end

  let :accept_event do
    Janice::Events::Accept.new(verification)
  end

  let :reject_event do
    Janice::Events::Reject.new(verification)
  end

  it "should output stuff" do
    formatter.verification_accept(accept_event)
    formatter.verification_reject(reject_event)

    expect(output.string).to eq ".F"
  end
end
