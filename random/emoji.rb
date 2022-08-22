#!/usr/bin/env ruby

# SOURCE: https://gist.github.com/iilei/4a4b4b1597d480d0f1b2
# Encoding: utf-8
#
# Usage examples:
#   random_emoji.rb
#   random_emoji.rb 3 emoti
#   random_emoji.rb 3 emoji
#   random_emoji.rb emoji-all
#   random_emoji.rb 42 all

# Miscellaneous Symbols and Pictographs - http://unicode.org/charts/PDF/U1F300.pdf
# Range: 1F300 – 1F5FF (127744 - 128511)
EMOJI_CODEPOINT_RANGE = (127744..128511)
EMOTI_CODEPOINT_RANGE = (128512..128591)

# exclude some codepoints - those are missing on yosemite
EXCLUDE_CODEPOINT_RANGES = {
  emoji: [
    (127778..127791),
    (127869..127871),
    (127892..127903),
    (127941..127941), # a range, for simplicity
    (127947..127967),
    (127983..127999),
    (128248..128248), # again, a range
    (128252..128292),
    (128306..128506), # contains present emojis but boring ones
  ],
  emoti: [
    (128577..128580)
  ]
}

class Emoji
  def initialize(count=1, scope=nil)
    @count = count
    @scope = scope
    print
  end

  def rand_in(min, max)
    rand(max-min+1) + min
  end

  def codepoint_procs(scope, all=false)
    range = self.class.const_get "#{scope.to_s.upcase}_CODEPOINT_RANGE"
    return [ ->{ rand_in range.min, range.max } ] if all
    excluded = EXCLUDE_CODEPOINT_RANGES[scope.to_sym]
    result = [ ->{ rand_in(range.min, excluded.first.min-1) } ].tap do |arr|
      (excluded.size-1).times do |index|
        arr << ->{ rand_in(excluded[index].max+1, excluded[index+1].min-1) }
      end
    end
    result << ->{ rand_in(excluded.last.max+1, range.max) }
  end

  def codepoint_procs_considered
    case @scope

    when "emoji"
      return codepoint_procs(:emoji)
    when "emoji-all"
      return codepoint_procs(:emoji, true)
    when "emoti"
      return codepoint_procs(:emoti)
    when "emoti-all"
      return codepoint_procs(:emoti, true)
    when "all"
      return codepoint_procs(:emoji, true) + codepoint_procs(:emoti, true)
    else
      return codepoint_procs(:emoji) + codepoint_procs(:emoti)
    end
  end

  def print
    puts (1..@count).map { codepoint_procs_considered.sample.call.chr('UTF-8') }
  end
end

################################################################################
## use it already
################################################################################

# if a number is passed, that much emo*is will be generated
output_count = (ARGV.map(&:to_i) - [0]).first || 1

# strings like "emoji", "emoti", "emoji-all", "emoti-all", "all" may be passed to provide a scope
scope = (["emoji", "emoti", "emoji-all", "emoti-all", "all"] & ARGV).first || "emoti-emoji-all"

# print it straightforward
Emoji.new(output_count, scope)
