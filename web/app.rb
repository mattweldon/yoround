require 'sinatra'
require 'faraday'
require 'json'

require_relative '../core'
require_relative '../infra'
require_relative '../config'

require_relative 'views/index'

class App < Sinatra::Application
  configure do
    #set :root, File.expand_path('../..', __FILE__)
    set :root, File.dirname(__FILE__)
    set :views, Proc.new { File.join(File.expand_path('../', __FILE__), "templates") }

    Repository.configure(
      "Drinker"   => Repositories::Sqlite::DrinkerRepository.new,
      "Round"     => Repositories::Sqlite::RoundRepository.new,
      "Settings"  => Repositories::Sqlite::SettingsRepository.new
    )

    Connection.configure(Connections::Faraday.new)

    settings = Settings.new
    settings.high_round_demand = 6
    settings.long_round_gap_hours = 1
    settings.min_round_gap_hours = 0.25
    Repository.for("Settings").save(settings)

    Configuration::DrinkerSetup.run(ENV['ENVIRONMENT'])
    Configuration::RoundSetup.run(ENV['ENVIRONMENT'])
  end 

  get '/' do
    erb :index, { :locals => { :view => IndexView.new.build } }
  end

  get '/yo' do
    ProcessYo.new(params[:username], Time.now).run
  end

  # Checks to see if there's a round to do
  get '/check-round' do
    round = Repository.for("Round").all.first
    CheckRoundNeeded.new(round, Time.now).run do
      return "OK"
    end
    return "FAIL"
  end

  get '/pick-brewer' do
    round = Repository.for("Round").all.first
    puts round
    CheckRoundNeeded.new(round, Time.now).run do
      brewer = PickBrewer.new.find
      NotifyBrewer.new(brewer.name).run
    end
  end

end