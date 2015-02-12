require 'time_difference'

class CheckRoundNeeded

  def initialize(round, time_now)
    @round = round
    @settings = Repository.for("Settings").all.first
    @time_now = time_now
  end

  def run
    # Check if the time is within the working day.
    # working_day = Range.new(
    #   Time.local(@time_now.year, @time_now.month, @time_now.day, 9).to_i,
    #   Time.local(@time_now.year, @time_now.month, @time_now.day, 18).to_i
    # ) === @time_now.to_i

    # puts "#{@time_now.year} / #{@time_now.month} / #{@time_now.day}"
    # puts "Start Day: #{Time.local(@time_now.year, @time_now.month, @time_now.day, 9).to_i}"
    # puts "End Day: #{Time.local(@time_now.year, @time_now.month, @time_now.day, 18).to_i}"
    # puts "Time now: #{@time_now.to_i}"
    # puts "Are we in the working day? #{working_day}"

    working_day = true
    if working_day
      if (high_demand? || been_a_while?(@time_now)) && min_time_passed?(@time_now)
        puts "a round is needed providing a nomination isn't already in progress"
        unless nomination_in_progress?
          puts "a round is needed... notify the brewer"
          yield if block_given?
        end
      end
    end
  end

  def high_demand?
    @round.current_demand.count >= @settings.high_round_demand
  end

  def been_a_while?(time)
    TimeDifference.between(@round.time_last_made, time).in_hours > @settings.long_round_gap_hours
  end

  def min_time_passed?(time)
    TimeDifference.between(@round.time_last_made, time).in_hours > @settings.min_round_gap_hours
  end

  def nomination_in_progress?
    @round.nominated_brewer.length > 0
  end

end