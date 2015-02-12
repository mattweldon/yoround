require_relative "spec_helper"

describe ProcessYo do

  before do
    configure_repository_mappings
    Configuration::DrinkerSetup.run(:development)
    Configuration::RoundSetup.run(:development)
  end

  describe "#most_recent_yos" do

    it "returns the most recent yos within 1 minute of each other" do
      drinker = Repository.for("Drinker").find_by_name("NORI")
      drinker.yo_history << Time.new(2014, 07, 18, 9, 3, 0)
      drinker.yo_history << Time.new(2014, 07, 18, 9, 3, 5)
      drinker.yo_history << Time.new(2014, 07, 18, 9, 2, 5)
      drinker.yo_history << Time.new(2014, 07, 18, 9, 1, 5)

      process_yo = ProcessYo.new("NORI", Time.new(2014, 07, 18, 9, 0, 30))
      
      expect(process_yo.most_recent_yos.count).to eq(2)
    end

  end

  describe "#is_safe_to_process?" do
  
    it "returns true if the last yo is older than 1 minute" do

      drinker = Repository.for("Drinker").find_by_name("NORI")
      drinker.yo_history << Time.new(2014, 07, 18, 9, 0, 0)
      drinker.yo_history << Time.new(2014, 07, 18, 9, 0, 5)

      expect(ProcessYo.new("NORI", Time.new(2014, 07, 18, 9, 1, 6)).is_safe_to_process?).to be_truthy
    end
  
  
    it "returns false if the last yo is younger than 1 minute" do

      drinker = Repository.for("Drinker").find_by_name("NORI")
      drinker.yo_history << Time.new(2014, 07, 18, 9, 0, 0)
      drinker.yo_history << Time.new(2014, 07, 18, 9, 0, 5)

      expect(ProcessYo.new("NORI", Time.new(2014, 07, 18, 9, 0, 30)).is_safe_to_process?).to be_falsey
    end

  end

end