class ListDrinkers

  def run
    Repository.for("Drinker").all
  end

end