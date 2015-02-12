class Drinker
  
  attr_accessor :id, :name, :num_rounds_made, :last_round_made, :is_nominated, :nominated_at, :yo_history

  def initialize(name)
    @name = name
    @num_rounds_made = 0
    @last_round_made = Time.new(9999, 12, 31)
    @is_nominated = false
    @nominated_at = Time.new(9999, 12, 31)
    @yo_history = []
  end

end