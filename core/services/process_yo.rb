require 'json'

class ProcessYo

  def initialize(name, time)
    @name = name
    @drinker = Repository.for("Drinker").find_by_name(name)
    @time = time
  end

  def run
    if @drinker.nil?
      RegisterDrinker.new(@name).run
      return
    end

    update_yo_history

    if @drinker.is_nominated
      if most_recent_yos.count == 1
        # 1 Yo means someone's thirsty
        StartRound.new(@drinker.name, @time).run do
          NotifyDrinkers.new.run
        end
      elsif most_recent_yos.count == 2
        SkipRound.new(@drinker.name, @time).run
      end
    else
      if most_recent_yos.count == 1
        # 1 Yo means someone's thirsty
        AddDrinkerDemand.new(@drinker.name).run
      elsif most_recent_yos.count == 2
        StartRound.new(@drinker.name, @time).run do
          NotifyDrinkers.new.run
        end
      end
    end


  end

  def update_yo_history
    @drinker.yo_history << @time
    Repository.for("Drinker").save(@drinker)
  end

  def is_safe_to_process?
    TimeDifference.between(most_recent_yos.max, @time).in_minutes > 0.5
  end

  def most_recent_yos
    most_recent_yos = []
    most_recent = @drinker.yo_history.max

    if most_recent.nil?

    else
      @drinker.yo_history.each do |yo|
        if TimeDifference.between(yo, most_recent).in_minutes >= 0.5
          next
        else
          most_recent_yos << yo
        end
      end
    end

    most_recent_yos.compact
  end

end