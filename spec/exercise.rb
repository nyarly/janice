require 'janice/model/exercise'

describe Janice::Exercise do
  describe "without any configuration" do
    let :exercise do
      Janice::Exercise.new
    end

    it "should not validate from scratch" do
      expect(exercise.valid?).not_to be_truthy
    end

    it "should reject non-Subject consequents" do
      expect{
        exercise.consequent = "some dumb thing"
      }.to raise_error(Janice::DescriptionError)
    end
  end

  describe "with action and consequent" do
    let :exercise do
      exercise = Janice::Exercise.new
      exercise.action do |subject, registry|
        subject + 1
      end
      exercise.consequent = Janice::Subject.new("a before")
      exercise
    end

    it "should validate with an action and consequent" do
      expect(exercise.valid?).not_to be_truthy
    end
  end

  describe "with antecedent, action and consequent" do
    let :exercise do
      exercise = Janice::Exercise.new
      exercise.antecedent = Janice::Subject.new("before")
      exercise.action do |subj, registry|
        subj + 1
      end
      exercise.consequent = Janice::Subject.new("after")
      exercise
    end

    it "should validate with an action and consequent" do
      expect(exercise.valid?).to be_truthy
    end

    it "should reject reassignment of its antecedent" do
      expect {
        exercise.antecedent = Janice::Subject.new("before two")
      }.to raise_error(Janice::DescriptionError)
    end

    it "should reject reassignment of its consequent" do
      expect {
        exercise.consequent = Janice::Subject.new("after two")
      }.to raise_error(Janice::DescriptionError)
    end

    let :registry do
      Janice::SubjectRegistry.new
    end

    it "should associate itself to its subjects" do
      expect(exercise.antecedent.antecedent_of).to include(exercise)
      expect(exercise.consequent.consequent_of).to include(exercise)
    end

    it "should perform its action" do
      expect(exercise.action[3, registry]).to eq(4)
    end
  end
end
