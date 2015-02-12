require_relative "spec_helper"

describe StartRound do
  before do
    configure_repository_mappings
    Configuration::DrinkerSetup.run(:development)
    Configuration::RoundSetup.run(:development)
  end

  let(:now) {
    Time.new(2014, 02, 01)
  }

  let(:start_round) {
    StartRound.new("NORI", now)
  }

  describe "#run" do

    it "clears the nominated brewer from the round" do
      round = Repository.for("Round").all.first
      round.nominated_brewer = "test"
      Repository.for("Round").save(round)

      start_round.run

      round = Repository.for("Round").all.first
      expect(round.nominated_brewer).to eq("")
    end

    it "sets person_last_brewed for the round" do
      round = Repository.for("Round").all.first
      Repository.for("Round").save(round)

      start_round.run

      round = Repository.for("Round").all.first
      expect(round.person_last_brewed).to eq("NORI")
    end

    it "sets time_last_made to now" do
      round = Repository.for("Round").all.first
      round.time_last_made = Time.new(2014, 01, 01)
      Repository.for("Round").save(round)

      start_round.run

      round = Repository.for("Round").all.first
      expect(round.time_last_made).to eq(Time.new(2014, 02, 01))
    end

    it "clears the current demand" do
      round = Repository.for("Round").all.first
      round.current_demand << "1"
      round.current_demand << "2"
      round.current_demand << "3"
      round.current_demand << "4"

      Repository.for("Round").save(round)

      start_round.run

      round = Repository.for("Round").all.first
      expect(round.current_demand.count).to eq(0)
    end

    it "increments the number of rounds made" do
      start_round.run
      drinker = Repository.for("Drinker").find_by_name("NORI")

      expect(drinker.num_rounds_made).to eq(1)
    end

    it "increments the number of rounds made" do
      start_round.run
      drinker = Repository.for("Drinker").find_by_name("NORI")

      expect(drinker.last_round_made).to eq(now)
    end

    it "removes nomination" do
      start_round.run
      drinker = Repository.for("Drinker").find_by_name("NORI")

      expect(drinker.is_nominated).to be_falsey
    end

  end

end