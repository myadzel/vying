# Copyright 2007, Eric Idema except where otherwise noted.
# You may redistribute / modify this file under the same terms as Ruby.

# Container for constants related to the vying library

module Vying
  
  # Returns the version of this vying codebase.

  def self.version
    v = const_defined?( :VERSION ) ? VERSION : "git master"
    "#{v}"
  end
end

require 'yaml'

require 'vying/ruby'
require 'vying/dup'
require 'vying/memoize'

require 'vying/parts/board'
require 'vying/parts/dice'
require 'vying/parts/cards/card'

require 'vying/user'
require 'vying/random'
require 'vying/option'
require 'vying/position'
require 'vying/notation'
require 'vying/rules/card/trick/trick'
require 'vying/rules'
require 'vying/player'
require 'vying/move'
require 'vying/special_move'
require 'vying/history'
require 'vying/game'
require 'vying/ai/search'
require 'vying/ai/book'
require 'vying/ai/bot'

# The version file is generated by 'rake version' for tagged versions of the
# library.  So, it may not be present.

begin
  require 'vying/version'
rescue LoadError
  nil
end

# Load all SpecialMoves, Rules, Notations, and Bots

SpecialMove.require_all
Rules.require_all
Notation.require_all
Bot.require_all( $:.select { |p| p =~ /vying/ } )

