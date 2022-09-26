require 'rspec'
require_relative '../alien'

describe Alien do
  it 'Should only be able to talk to Characters' do
    alien = Alien.new
    rock = Rock.new
    expect(alien.can_talk_to?(rock)).to be(false)
  end

  it 'Should be able to talk to Humans' do
    alien = Alien.new
    human = Human.new
    expect(alien.can_talk_to?(human)).to be(true)
  end

  it 'Should be able to talk to Aliens' do
    alien = Alien.new
    other_alien = Alien.new
    expect(alien.can_talk_to?(other_alien)).to be(true)
  end

  it 'Should not be able to talk to Cyborgs' do
    alien = Alien.new
    cyborg = Cyborg.new
    expect(alien.can_talk_to?(cyborg)).to be(false)
  end
end
