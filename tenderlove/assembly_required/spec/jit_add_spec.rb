require 'rspec'
require_relative '../jit'

def add
  5 + 3
end

describe JIT do
  it 'Should compile an addition funtion' do
    result = JIT.new(method(:add)).compile.call
    expect(result).to eq(add)
  end

  it 'Should define a singleton method' do
    jit = JIT.new(method(:add))
    jit.define 'add'
    expect(jit.jit_add).to eq(add)
  end
end
