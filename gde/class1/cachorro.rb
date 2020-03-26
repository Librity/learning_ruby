class Cachorro
  attr_accessor :name, :weight, :color, :race, :age

  def som
    'Au Au'
  end

  def compute_age(year)
    self.age = 2020 - year.to_i
  end
end
