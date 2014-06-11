require 'janice/subject-registry'

describe Janice::SubjectRegistry do
  let :registry do
    Janice::SubjectRegistry.new
  end

  it "should create subjects as needed" do
    expect(registry["some name"]).not_to be_nil
  end

  it "should return Janice::Subjects" do
    expect(registry["whatever"]).to be_a(Janice::Subject)
  end

  it "should consistently return the same subject" do
    expect(registry["another name"]).to equal(registry["another name"])
  end

  it "should make the root_void available" do
    expect(registry.root_void).to be_a(Janice::Subject)
  end
end
