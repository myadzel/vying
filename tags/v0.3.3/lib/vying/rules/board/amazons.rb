require 'vying/rules'
require 'vying/board/amazons'

class Amazons < Rules

  info :name      => "Amazons",
       :resources => ['Wikipedia <http://en.wikipedia.org/wiki/Amazons_(game)>']

  attr_reader :board, :lastc

  players [:white, :black]

  def initialize( seed=nil )
    super

    @board = AmazonsBoard.new

    @lastc = nil
  end

  def move?( move, player=nil )
    return false unless player.nil? || has_moves.include?( player )
    return false if final?
    return false unless move.to_s =~ /(\w\d+)(\w\d+)/

    sc = Coord[$1]
    ec = Coord[$2]

    queens = board.occupied[turn]

    return false unless queens.include?( sc )
    return false unless d = sc.direction_to( ec )

    ic = sc
    while (ic = board.coords.next( ic, d ))
      return false if !board[ic].nil?
      break        if ic == ec
    end

    return true
  end

  def moves( player=nil )
    return []          unless player.nil? || has_moves.include?( player )

    a = []

    queens = board.occupied[turn]

    if lastc.nil? || board[lastc] == :arrow
      queens.each do |q|
        board.mobility[q].each { |ec| a << "#{q}#{ec}" }
      end
    else
      board.mobility[lastc].each { |ec| a << "#{lastc}#{ec}" }
    end

    a
  end

  def apply!( move )
    coords = move.to_coords

    if lastc.nil? || board[lastc] == :arrow
      board.move( coords.first, coords.last )
    else
      board.arrow( coords.last )
      turn( :rotate )
    end

    @lastc = coords.last 

    self
  end

  def final?
    moves.empty?
  end

  def winner?( player )
    player != turn
  end

  def loser?( player )
    player == turn
  end

  def score( player )
    board.territory( player ).length
  end

  def hash
    [board,turn].hash
  end
end
