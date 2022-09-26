class Rock
end

class Character
end

class Cyborg < Character
end

class Human < Character
end

class Alien < Character
  TALKABLE_RACES = [Alien, Human]

  def can_talk_to?(character)
    return false unless character.is_a?(Character)

    TALKABLE_RACES.each do |race|
      return true if character.is_a?(race)
    end

    false
  end
end
