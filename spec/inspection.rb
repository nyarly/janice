require 'janice/model/inspection'

describe Janice::Inspection do
  let :inspection do
    Janice::Inspection.new
  end

  let :verification do
    double("Verification")
  end

  it "should be able to add verifications" do
    inspection.add(verification)

    expect(inspection.all).to include(verification)
  end

  it "should set and return an inspection block" do
    block = lambda{}
    inspection.inspect(&block)

    expect(inspection.inspect).to equal(block)
  end
end
