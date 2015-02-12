require_relative "spec_helper"

describe PickBrewer do
  before do
    configure_repository_mappings
    Configuration::DrinkerSetup.run(:development)
    Configuration::RoundSetup.run(:development)
    srand(67809)
  end

  it "picks a random brewer to start with" do
    brewer = PickBrewer.new.find
    expect(brewer.name).to eq("NORI")
  end

  it "picks those that have brewed the least" do
    brewer = PickBrewer.new.find
    brewer = PickBrewer.new.find
    expect(brewer.name).to eq("ORI")
  end


end