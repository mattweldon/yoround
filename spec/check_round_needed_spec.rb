require_relative "spec_helper"

describe CheckRoundNeeded do
  before do
    configure_repository_mappings
    Configuration::DrinkerSetup.run
  end

  let(:round) {
    round = Round.new
    Repository.for("Round").save(round)
    round
  }

  let(:current_time) {
    Time.new(2014, 07, 17, 9, 2, 0)
  }

  let(:start_high_demand_round) {
    CheckRoundNeeded.new(round, current_time)
  }

  describe "#run" do

    let(:high_demand_round) {
      round.current_demand << "1"
      round.current_demand << "2"
      round.current_demand << "3"
      round.current_demand << "4"
      CheckRoundNeeded.new(round, Time.new(2014, 07, 17, 9, 40, 0))
    }

    let(:quick_high_demand_round) {
      round.current_demand << "1"
      round.current_demand << "2"
      round.current_demand << "3"
      round.current_demand << "4"
      round.time_last_made = Time.new(2014, 07, 17, 9, 0, 0)
      CheckRoundNeeded.new(round, Time.new(2014, 07, 17, 9, 20, 0))
    }

    let(:long_round) {
      CheckRoundNeeded.new(round, Time.new(2014, 07, 17, 11, 0, 0))
    }

    it "calls block if high demand and min time has passed" do
      block_called = false
      high_demand_round.run { |b| block_called = true }
      expect(block_called).to be_truthy
    end

    it "doesn't call block if high demand but min time not passed" do
      block_called = false
      quick_high_demand_round.run { |b| block_called = true }
      expect(block_called).to be_falsey
    end

    it "calls block if max time passed but no interest" do
      block_called = false
      long_round.run { |b| block_called = true }
      expect(block_called).to be_truthy
    end

  end


  describe "#high_demand?" do
    let(:start_high_demand_round) {
      round.current_demand << "1"
      round.current_demand << "2"
      round.current_demand << "3"
      round.current_demand << "4"
      CheckRoundNeeded.new(round, current_time)
    }

    let(:start_low_demand_round) {
      round.current_demand << "1"
      CheckRoundNeeded.new(round, current_time)
    }

    it "returns true when the queue hits the high demand setting" do
      expect(start_high_demand_round.high_demand?).to be_truthy
    end

    it "returns false when the queue doesn't hit the high demand setting" do
      expect(start_low_demand_round.high_demand?).to be_falsey
    end
  end

  describe "#been_a_while?" do
    let(:start_round) {
      round.time_last_made = Time.new(2014, 07, 17, 9, 0, 0)
      CheckRoundNeeded.new(round, current_time)
    }

    it "returns true if it's been longer than the max gap setting" do
      expect(start_round.been_a_while?(Time.new(2014, 07, 17, 11, 0, 0))).to be_truthy
    end

    it "returns false if it's been less than the max gap setting" do
      expect(start_round.been_a_while?(Time.new(2014, 07, 17, 9, 30, 0))).to be_falsey
    end
  end

  describe "#min_time_passed?" do
    let(:start_round) {
      round.time_last_made = Time.new(2014, 07, 17, 9, 0, 0)
      CheckRoundNeeded.new(round, current_time)
    }

    it "returns true if it's been longer than the min gap setting" do
      expect(start_round.min_time_passed?(Time.new(2014, 07, 17, 9, 40, 0))).to be_truthy
    end

    it "returns false if it's been less than the min gap setting" do
      expect(start_round.min_time_passed?(Time.new(2014, 07, 17, 9, 20, 0))).to be_falsey
    end
  end


end