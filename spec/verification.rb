require 'janice/model/verification'

describe Janice::Verification do
  describe Janice::Verification::Eql do
    let :verification do
      Janice::Verification::Eql.new(6)
    end

    it "should return true for match" do
      expect(verification.match?(6)).to eq(true)
    end

    it "should return false for mismatch" do
      expect(verification.match?(7)).to eq(false)
    end
  end

  describe Janice::Verification::Adhoc do
    let :verification do
      Janice::Verification::Adhoc.new do |actual|
        actual == 6
      end
    end

    it "should return true for match" do
      expect(verification.match?(6)).to eq(true)
    end

    it "should return false for mismatch" do
      expect(verification.match?(7)).to eq(false)
    end
  end
end
