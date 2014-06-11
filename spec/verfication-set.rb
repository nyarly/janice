require 'janice/model/verification-set'

describe Janice::VerificationSet do
  let :set do
    Janice::VerificationSet.new
  end

  let :equal_five do
    Janice::Verification::Eql.new(5)
  end

  it "should add verifications" do
    set.add(equal_five)
    expect(set.all).to include(equal_five)
  end
end
