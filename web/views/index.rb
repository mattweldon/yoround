require 'time_difference'
class IndexView

  attr_accessor :minutes_since_last_round, :last_brewer
  attr_accessor :nominated_brewer, :minutes_since_nomination
  attr_accessor :drinkers

  def build

    @round_info = GetRoundInfo.run

    @last_brewer = @round_info.person_last_brewed

    @minutes_since_last_round = Integer(TimeDifference.between(@round_info.time_last_made, Time.now).in_minutes)

    @nominated_brewer = @round_info.nominated_brewer
    @minutes_since_nomination = Integer(TimeDifference.between(@round_info.time_nomination_made, Time.now).in_minutes)

    drinkers_list = ListDrinkers.new.run
    @drinkers = []

    drinkers_list.each do |d|
      drinker = OpenStruct.new
      drinker.name = d.name
      drinker.is_thirsty = @round_info.current_demand.include?(d.name)
      drinker.was_last_brewer = drinker.name == @round_info.person_last_brewed
      drinker.is_current_brewer = drinker.name == @nominated_brewer

      @drinkers << drinker
    end

    self
  end

  def brew_made_today?
    @last_brewer.length > 0 && @round_info.time_last_made.day == Time.now.day
  end

  def someone_nominated?
    @nominated_brewer.length > 0
  end

end