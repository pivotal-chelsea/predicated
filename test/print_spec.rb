require "test/test_helper"

require "predicated/predicate"

apropos "a predicate looks nice with you inspect it" do
  include Predicated
  
  test "numbers" do
    assert { Predicate { Eq(1, 1) }.inspect == "Eq(1,1)" }
    assert { Predicate { Lt(1, 2) }.inspect == "Lt(1,2)" }
  end
  
  test "booleans" do
    assert { Predicate { Eq(false, true) }.inspect == "Eq(false,true)" }
  end
  
  test "strings" do
    assert { Predicate { Eq("foo", "bar") }.inspect == "Eq('foo','bar')" }
  end

  class Color
    attr_reader :name
    def initialize(name)
      @name = name
    end
  
    def to_s
      "name:#{@name}"
    end
  end
    
  test "objects" do
    assert { Predicate { Eq(Color.new("red"), Color.new("blue")) }.inspect == "Eq(Color{'name:red'},Color{'name:blue'})" }
  end
  
  test "and, or" do
    assert { Predicate { And(true, false) }.inspect == "And(true,false)" }
    assert { Predicate { Or(true, false) }.inspect == "Or(true,false)" }
    
    assert { Predicate { And(Eq(1, 1) , Eq(2, 2)) }.inspect == "And(Eq(1,1),Eq(2,2))" }
    
    assert { Predicate { And(Eq(1, 1), Or(Eq(2, 2), Eq(3, 3))) }.inspect == "And(Eq(1,1),Or(Eq(2,2),Eq(3,3)))" }
  end

end

apropos "to_s is like inspect except it's multiline, so you see the tree structure" do
  include Predicated
  
  test "an uncomplicated predicate prints on one line" do
    assert { Predicate { Eq(1, 1) }.to_s == "Eq(1,1)" }
  end
  
  test "complex" do
    assert { 
      Predicate { And(Eq(1, 1), Or(Eq(2, 2), Eq(3, 3))) }.to_s == 
%{And(
  Eq(1,1),
  Or(
    Eq(2,2),
    Eq(3,3)
  )
)
}
    }
  end
end