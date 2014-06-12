require 'janice/model/subject'

describe Janice::Subject do
  let :subject do
    Janice::Subject.new('one')
  end

  let :producer do
    Janice::Exercise.new
  end

  let :consumer do
    Janice::Exercise.new
  end

  let :verifier do
    Janice::VerificationSet.new
  end

  it "should add producers only once" do
    subject.producer(producer)
    subject.producer(producer)
    subject.producer(producer)

    expect(subject.consequent_of.length).to eq(1)
    expect(subject.consequent_of).to contain_exactly(producer)
  end

  it "should add consumers only once" do
    subject.consumer(consumer)
    subject.consumer(consumer)
    subject.consumer(consumer)

    expect(subject.antecedent_of.length).to eq(1)
    expect(subject.antecedent_of).to contain_exactly(consumer)
  end

  it "should add verifiers only once" do
    expect(subject.has_verifications?).to be_falsy

    subject.verifier(verifier)
    subject.verifier(verifier)
    subject.verifier(verifier)

    expect(subject.has_verifications?).to be_truthy
    expect(subject.verification_sets.length).to eq(1)
    expect(subject.verification_sets).to contain_exactly(verifier)
  end
end
