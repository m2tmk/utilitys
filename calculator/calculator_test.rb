require 'test/unit'
require_relative 'calculator'

class InterestCalclatorTest < Test::Unit::TestCase
    def test_parse1
        from = Date.new(2012,12,10)
        to = Date.new(2013,1,20)

        terms = Calculator::Interest.parse(from, to, 27)
        terms.each do |t|
            p t
        end
    end

    def test_parse12
        from = Date.new(2012,12,10)
        to = Date.new(2013,3,20)

        terms = Calculator::Interest.parse(from, to, 27)
        terms.each do |t|
            p t
        end
    end
end
