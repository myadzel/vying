require "test/unit"

require "vying/board/standard"

class TestCoord < Test::Unit::TestCase
  def test_initialize
    c = Coord[0,1]
    assert_equal( 0, c.x )
    assert_equal( 1, c.y )
    assert_equal( c, Coord.new( 0, 1 ) )

    c = Coord[:a2]
    assert_equal( 0, c.x )
    assert_equal( 1, c.y )
    assert_equal( c, Coord.new( 0, 1 ) )

    c = Coord["A2"]
    assert_equal( 0, c.x )
    assert_equal( 1, c.y )
    assert_equal( c, Coord.new( 0, 1 ) )
  end

  def test_equal
    c1 = Coord[0,0]
    c2 = Coord[0,0]
    c3 = Coord[1,0]
    c4 = Coord[0,1]

    assert_equal( c1, c2 )
    assert_not_equal( c2, c3 )
    assert_not_equal( c1, c4 )
    assert_not_equal( c3, c4 )

    assert( c1 == c2 )
    assert( c1.eql?( c2 ) )
    assert( c3 != c4 )
  end

  def test_hash
    assert_equal( Coord[0,0], Coord[0,0] )
    assert_not_equal( Coord[0,0], Coord[0,1] )
  end

  def test_comparison
    unordered = [Coord[0,0],
                 Coord[-1,0],
                 Coord[-1,-1],
                 Coord[1,0],
                 Coord[0,-1],
                 Coord[1,1]]
    ordered = [Coord[-1,-1],
               Coord[0,-1],
               Coord[-1,0],
               Coord[0,0],
               Coord[1,0],
               Coord[1,1]]
    assert_equal( ordered, unordered.sort )
  end

  def test_addition
    c00 = Coord[0,0]
    c10 = Coord[1,0]
    c01 = Coord[0,1]
    c11 = Coord[1,1]
    c21 = Coord[2,1]
    c42 = Coord[4,2]

    assert_equal( c00, c00 + c00 )
    assert_equal( c10, c00 + c10 )
    assert_equal( c10, c10 + c00 )
    assert_equal( c11, c10 + c01 )
    assert_equal( c21, (c10 + c01) + c10 )
    assert_equal( c21, c10 + (c01 + c10) )
    assert_equal( c42, c21 + c21 )
  end

  def test_direction_to
    c = Coord[3,3]

    assert_equal( :n, c.direction_to( Coord[3,0] ) )
    assert_equal( :s, c.direction_to( Coord[3,5] ) )
    assert_equal( :e, c.direction_to( Coord[6,3] ) )
    assert_equal( :w, c.direction_to( Coord[2,3] ) )

    assert_equal( :ne, c.direction_to( Coord[5,1] ) )
    assert_equal( :nw, c.direction_to( Coord[2,2] ) )
    assert_equal( :se, c.direction_to( Coord[5,5] ) )
    assert_equal( :sw, c.direction_to( Coord[0,6] ) )

    assert_equal( nil, c.direction_to( Coord[4,1] ) )
    assert_equal( nil, c.direction_to( Coord[2,1] ) )
    assert_equal( nil, c.direction_to( Coord[5,6] ) )
    assert_equal( nil, c.direction_to( Coord[1,6] ) )
  end

  def test_to_s
    assert_equal( "a1", Coord[0,0].to_s )
    assert_equal( "b3", Coord[1,2].to_s )
  end

  def test_from_s
    assert_equal( Coord[0,0], Coord['a1'] )
    assert_equal( Coord[1,2], Coord[:b3] )
  end
end

class TestCoords < Test::Unit::TestCase
  def test_initialize
    coords = Coords.new( 3, 4 )
    assert_equal( 3, coords.width )
    assert_equal( 4, coords.height )
  end

  def test_each
    coords = Coords.new( 2, 3 )
    a = [Coord[0,0], Coord[1,0], Coord[0,1],
         Coord[1,1], Coord[0,2], Coord[1,2]]
    i = 0
    coords.each { |c| assert_equal( a[i], c ); i += 1 }
  end

  def test_include
    coords = Coords.new( 2, 3 )

    assert( coords.include?( Coord[0,0] ) )
    assert( coords.include?( Coord[1,0] ) )
    assert( coords.include?( Coord[0,2] ) )
    assert( coords.include?( Coord[1,2] ) )
    assert( coords.include?( Coord[1,1] ) )

    assert( ! coords.include?( Coord[-1,0] ) )
    assert( ! coords.include?( Coord[0,-1] ) )
    assert( ! coords.include?( Coord[-1,-1] ) )
    assert( ! coords.include?( Coord[2,0] ) )
    assert( ! coords.include?( Coord[0,3] ) )
    assert( ! coords.include?( Coord[2,3] ) )
    assert( ! coords.include?( Coord[100,100] ) )
  end

  def test_row
    coords = Coords.new( 2, 3 )

    assert_equal( 2, coords.row( Coord[0,0] ).length )
    assert_equal( 2, coords.row( Coord[0,1] ).length )
    assert_equal( 2, coords.row( Coord[0,2] ).length )

    assert_equal( [Coord[0,0], Coord[1,0]], coords.row( Coord[0,0] ) )
    assert_equal( [Coord[0,0], Coord[1,0]], coords.row( Coord[1,0] ) )

    assert_equal( [Coord[0,1], Coord[1,1]], coords.row( Coord[0,1] ) )
    assert_equal( [Coord[0,1], Coord[1,1]], coords.row( Coord[1,1] ) )

    assert_equal( [Coord[0,2], Coord[1,2]], coords.row( Coord[0,2] ) )
    assert_equal( [Coord[0,2], Coord[1,2]], coords.row( Coord[1,2] ) )
  end

  def test_column
    coords = Coords.new( 2, 3 )

    assert_equal( 3, coords.column( Coord[0,0] ).length )
    assert_equal( 3, coords.column( Coord[1,0] ).length )

    col1 = [Coord[0,0], Coord[0,1], Coord[0,2]]
    col2 = [Coord[1,0], Coord[1,1], Coord[1,2]]

    assert_equal( col1, coords.column( Coord[0,0] ) )
    assert_equal( col1, coords.column( Coord[0,1] ) )
    assert_equal( col1, coords.column( Coord[0,2] ) )

    assert_equal( col2, coords.column( Coord[1,0] ) )
    assert_equal( col2, coords.column( Coord[1,1] ) )
    assert_equal( col2, coords.column( Coord[1,2] ) )
  end

  def test_diagonal
    coords = Coords.new( 2, 3 )

    diag1p = [Coord[0,0], Coord[1,1]]
    diag2p = [Coord[1,0]]
    diag3p = [Coord[0,1], Coord[1,2]]
    diag4p = [Coord[0,2]]

    diag1n = [Coord[0,0]]
    diag2n = [Coord[1,0], Coord[0,1]]
    diag3n = [Coord[1,1], Coord[0,2]]
    diag4n = [Coord[1,2]]

    assert_equal( 2, coords.diagonal( Coord[0,0], 1 ).length )
    assert_equal( 1, coords.diagonal( Coord[1,0], 1 ).length )
    assert_equal( 2, coords.diagonal( Coord[0,1], 1 ).length )
    assert_equal( 1, coords.diagonal( Coord[0,2], 1 ).length )

    assert_equal( 1, coords.diagonal( Coord[0,0], -1 ).length )
    assert_equal( 2, coords.diagonal( Coord[1,0], -1 ).length )
    assert_equal( 2, coords.diagonal( Coord[1,1], -1 ).length )
    assert_equal( 1, coords.diagonal( Coord[1,2], -1 ).length )

    assert_equal( diag1p, coords.diagonal( Coord[0,0], 1 ) )
    assert_equal( diag1p, coords.diagonal( Coord[1,1], 1 ) )

    assert_equal( diag2p, coords.diagonal( Coord[1,0], 1 ) )

    assert_equal( diag3p, coords.diagonal( Coord[0,1], 1 ) )
    assert_equal( diag3p, coords.diagonal( Coord[1,2], 1 ) )

    assert_equal( diag4p, coords.diagonal( Coord[0,2], 1 ) )

    assert_equal( diag1p, coords.diagonal( Coord[0,0] ) )
    assert_equal( diag1p, coords.diagonal( Coord[1,1] ) )

    assert_equal( diag2p, coords.diagonal( Coord[1,0] ) )

    assert_equal( diag3p, coords.diagonal( Coord[0,1] ) )
    assert_equal( diag3p, coords.diagonal( Coord[1,2] ) )

    assert_equal( diag4p, coords.diagonal( Coord[0,2] ) )

    assert_equal( diag1n, coords.diagonal( Coord[0,0], -1 ) )

    assert_equal( diag2n, coords.diagonal( Coord[1,0], -1 ) )
    assert_equal( diag2n, coords.diagonal( Coord[0,1], -1 ) )

    assert_equal( diag3n, coords.diagonal( Coord[1,1], -1 ) )
    assert_equal( diag3n, coords.diagonal( Coord[0,2], -1 ) )

    assert_equal( diag4n, coords.diagonal( Coord[1,2], -1 ) )
  end

  def test_neighbors
    coords = Coords.new( 8, 8 )

    n00 = [Coord[0,1], Coord[1,0], Coord[1,1]]
    n70 = [Coord[6,0], Coord[7,1], Coord[6,1]]
    n07 = [Coord[0,6], Coord[1,7], Coord[1,6]]
    n77 = [Coord[7,6], Coord[6,7], Coord[6,6]]
    n30 = [Coord[2,0], Coord[4,0], Coord[2,1], Coord[3,1], Coord[4,1]]
    n03 = [Coord[0,2], Coord[0,4], Coord[1,2], Coord[1,3], Coord[1,4]]
    n37 = [Coord[2,7], Coord[4,7], Coord[2,6], Coord[3,6], Coord[4,6]]
    n73 = [Coord[7,2], Coord[7,4], Coord[6,2], Coord[6,3], Coord[6,4]]
    n33 = [Coord[2,3], Coord[4,3], Coord[3,2], Coord[3,4],
           Coord[2,2], Coord[4,4], Coord[2,4], Coord[4,2]]

    a00 = coords.neighbors( Coord[0,0] ).reject { |c| c.nil? }
    a70 = coords.neighbors( Coord[7,0] ).reject { |c| c.nil? }
    a07 = coords.neighbors( Coord[0,7] ).reject { |c| c.nil? }
    a77 = coords.neighbors( Coord[7,7] ).reject { |c| c.nil? }
    a30 = coords.neighbors( Coord[3,0] ).reject { |c| c.nil? }
    a03 = coords.neighbors( Coord[0,3] ).reject { |c| c.nil? }
    a37 = coords.neighbors( Coord[3,7] ).reject { |c| c.nil? }
    a73 = coords.neighbors( Coord[7,3] ).reject { |c| c.nil? }
    a33 = coords.neighbors( Coord[3,3] ).reject { |c| c.nil? }

    assert_equal( n00.sort, a00.sort )
    assert_equal( n70.sort, a70.sort )
    assert_equal( n07.sort, a07.sort )
    assert_equal( n77.sort, a77.sort )
    assert_equal( n30.sort, a30.sort )
    assert_equal( n03.sort, a03.sort )
    assert_equal( n37.sort, a37.sort )
    assert_equal( n73.sort, a73.sort )
    assert_equal( n33.sort, a33.sort )

    assert_equal( [Coord[4,3]], coords.neighbors( Coord[4,4], [:n] ) )
    assert_equal( [Coord[4,5]], coords.neighbors( Coord[4,4], [:s] ) )
    assert_equal( [Coord[3,4]], coords.neighbors( Coord[4,4], [:w] ) )
    assert_equal( [Coord[5,4]], coords.neighbors( Coord[4,4], [:e] ) )
    assert_equal( [Coord[5,3]], coords.neighbors( Coord[4,4], [:ne] ) )
    assert_equal( [Coord[3,3]], coords.neighbors( Coord[4,4], [:nw] ) )
    assert_equal( [Coord[5,5]], coords.neighbors( Coord[4,4], [:se] ) )
    assert_equal( [Coord[3,5]], coords.neighbors( Coord[4,4], [:sw] ) )

    n44nssw = [Coord[4,3], Coord[4,5], Coord[3,5]]
 
    assert_equal( n44nssw, coords.neighbors( Coord[4,4], [:n,:s,:sw] ) )
  end

  def test_next
    coords = Coords.new( 8, 8 )

    assert_equal( Coord[0,1], coords.next( Coord[0,0], :s ) )
    assert_equal( Coord[1,0], coords.next( Coord[0,0], :e ) )
    assert_equal( nil,        coords.next( Coord[0,0], :n ) )
    assert_equal( nil,        coords.next( Coord[0,0], :w ) )

    assert_equal( Coord[7,1], coords.next( Coord[7,0], :s ) )
    assert_equal( nil,        coords.next( Coord[7,0], :e ) )
    assert_equal( nil,        coords.next( Coord[7,0], :n ) )
    assert_equal( Coord[6,0], coords.next( Coord[7,0], :w ) )

    assert_equal( nil,        coords.next( Coord[0,7], :s ) )
    assert_equal( Coord[1,7], coords.next( Coord[0,7], :e ) )
    assert_equal( Coord[0,6], coords.next( Coord[0,7], :n ) )
    assert_equal( nil,        coords.next( Coord[0,7], :w ) )

    assert_equal( nil,        coords.next( Coord[7,7], :s ) )
    assert_equal( nil,        coords.next( Coord[7,7], :e ) )
    assert_equal( Coord[7,6], coords.next( Coord[7,7], :n ) )
    assert_equal( Coord[6,7], coords.next( Coord[7,7], :w ) )
  end

  def test_to_s
    coords = Coords.new( 2, 2 )
    assert_equal( "a1b1a2b2", coords.to_s )
  end
end

class TestBoard < Test::Unit::TestCase
  def test_initialize
    b = Board.new( 3, 3 )
    assert_equal( Coords.new( 3, 3 ), b.coords )
    assert_equal( nil, b[0,0] ) 
  end

  def test_dup
    b = Board.new( 3, 3 )

    b[1,1] = :orig
    b2 = b.dup

    assert_equal( :orig, b[1,1] )
    assert_equal( :orig, b2[1,1] )

    b2[1,1] = :test

    assert_equal( :orig, b[1,1] )
    assert_equal( :test, b2[1,1] )
  end

  def test_equal
    b = Board.new( 3, 3 )
    assert( b == b )

    b2 = b.dup
    assert( b == b2 )
    assert( b2 == b )

    assert( b == Board.new( 3, 3 ) )

    b2[0,0] = :x
    assert( b != b2 )

    assert( b != Board.new( 4, 4 ) )
  end

  def test_assignment
    b = Board.new( 3, 3 )

    b[0,0] = :zero
    b[Coord.new(1,0)] = :one
    b[Coord[2,0]] = :two

    assert_equal( :zero, b[0,0] )
    assert_equal( :zero, b[Coord[0,0]] )
    assert_equal( [:zero,:two], b[[Coord[0,0], Coord[2,0]]] )
  end

  def test_each
    b = Board.new( 2, 2 )
    b[0,0] = :b00
    b[1,0] = :b10
    b[0,1] = :b01
    b[1,1] = :b11

    a = [:b00, :b10, :b01, :b11]
    i = 0

    b.each { |p| assert_equal( a[i], p ); i += 1 }
  end

  def test_each_from
    b = Board.new( 8, 8 )
    b[3,3] = :x
    b[3,4] = :x
    b[3,6] = :x
    b[2,2] = :o
    b[1,1] = :o
    b[0,0] = :o

    count1 = b.each_from( Coord[3,3], [:nw,:s] ) { |p| !p.nil? }
    count2 = b.each_from( Coord[3,3], [:nw,:s] ) { |p| p == :x }
    count3 = b.each_from( Coord[3,3], [:nw] ) { |p| p == :x }
    count4 = b.each_from( Coord[3,3], [:nw,:s] ) { |p| p == :o }
    count5 = b.each_from( Coord[3,6], [:nw,:s,:e,:w] ) { |p| !p.nil? }

    assert_equal( 4, count1 )
    assert_equal( 1, count2 )
    assert_equal( 0, count3 )
    assert_equal( 3, count4 )
    assert_equal( 0, count5 )
  end

  def test_count
    b = Board.new( 3, 3 )

    assert_equal( 9, b.count( nil ) )

    b[0,0] = :b00
    b[1,1] = :b11

    assert_equal( 7, b.count( nil ) )
    assert_equal( 1, b.count( :b00 ) )
    assert_equal( 1, b.count( :b11 ) )
    assert_equal( 0, b.count( :b22 ) )

    b[2,2] = :b22

    assert_equal( 1, b.count( :b22 ) )

    b[1,0] = b[1,1] = :x

    assert_equal( 2, b.count( :x ) )
    assert_equal( 0, b.count( :b11 ) )
  end

  def test_move
    b = Board.new( 3, 3 )
    b[0,0] = :x
    b[2,2] = :o

    assert_equal( :x, b[0,0] )
    assert_equal( :o, b[2,2] )
    assert_equal( nil, b[1,1] )

    b.move( Coord[0,0], Coord[1,1] )

    assert_equal( nil, b[0,0] )
    assert_equal( :o, b[2,2] )
    assert_equal( :x, b[1,1] )

    b.move( Coord[2,2], Coord[1,1] )

    assert_equal( nil, b[0,0] )
    assert_equal( nil, b[2,2] )
    assert_equal( :o, b[1,1] )
  end

  def test_to_s
    b = Board.new( 2, 2 )
    b[0,0] = '0'
    b[1,0] = '1'
    b[0,1] = '2'
    b[1,1] = '3'
   
    assert_equal( " ab \n1011\n2232\n ab \n", b.to_s )

    b = Board.new( 2, 10 )
    b[0,0], b[1,0], b[0,9], b[1,9] = 'a', 'b', 'c', 'd'
    s = <<EOF
  ab  
 1ab1 
 2  2 
 3  3 
 4  4 
 5  5 
 6  6 
 7  7 
 8  8 
 9  9 
10cd10
  ab  
EOF

    assert_equal( s, b.to_s )
  end

  def test_from_s
    s = <<EOF
 abcdefghi 
1  x  o   1
2a  bb   a2
3 rr  rr  3
 abcdefghi 
EOF

    pieces = [:x, :o, :red, :alpha, :beta]
    b = Board.from_s( pieces, s )

    assert_equal( 9, b.coords.width )
    assert_equal( 3, b.coords.height )

    assert_equal( :x, b[2,0] )
    assert_equal( :o, b[5,0] )

    assert_equal( :alpha, b[0,1] )
    assert_equal( :beta, b[3,1] )
    assert_equal( :beta, b[4,1] )
    assert_equal( :alpha, b[8,1] )

    assert_equal( :red, b[1,2] )
    assert_equal( :red, b[2,2] )
    assert_equal( :red, b[5,2] )
    assert_equal( :red, b[6,2] )

    assert_equal( 17, b.count( nil ) )
  end
end

