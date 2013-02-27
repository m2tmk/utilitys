require 'test/unit'
require_relative 'calculator'

class InterestCalclatorTest < Test::Unit::TestCase
    def test_parse1
        from = Date.new(2012,12,10)
        to = Date.new(2013,1,20)

        terms = Calculator::Interest.terms_by_cutoff_day(from, to, 27)
        terms.each do |t|
            p t
        end
    end

    def test_parse12
        from = Date.new(2012,12,10)
        to = Date.new(2013,3,20)

        terms = Calculator::Interest.terms_by_cutoff_day(from, to, 27)
        terms.each do |t|
            p t
        end
    end

    def test_parse_monthly1
        from = Date.new(2012,12,10)
        to = Date.new(2013,3,20)

        terms = Calculator::Interest.terms_by_end_of_month(from, to)
        terms.each do |t|
            p t
        end

        min_date = Date.new(2013,1,1)
        terms.select{ |e| e.first >= min_date }.each do |e|
            p e
        end
    end

    def test_parse_monthly12
        from = Date.new(2012,12,10)
        to = Date.new(2013,3,20)
        min_date = Date.new(2013,2,1)

        terms = Calculator::Interest.terms_by_end_of_month(from, to)
        terms.select{ |e| e.first >= min_date }.each do |e|
            p e
        end
    end

    def test_calc_leap1
        principal = 1000000
        rate = 3.6 
        from = Date.new(2012,12,10)
        to = Date.new(2013,1,27)

        p Calculator::Interest.calc_leap(principal, from, to, rate)
        p Calculator::Interest.calc_365(principal, from, to, rate)
    end

    def test_calc_leap2
        principal = 1000000
        rate = 3.6 
        from = Date.new(2012,12,10)
        to = Date.new(2012,12,31)

        p Calculator::Interest.calc(
            Calculator::Interest.both_end_base(principal, from, to), 366, rate)
        p Calculator::Interest.calc(
            Calculator::Interest.both_end_base(principal, from, to), 365, rate)
    end

    def test_calc_leap3
        principal = 1000000
        rate = 3.6 
        from = Date.new(2013,1,1)
        to = Date.new(2013,1,27)

        doy = Calculator::Interest.days_of_year(to)

        p Calculator::Interest.calc(
            Calculator::Interest.one_end_base(principal, from, to), 365, rate)
    end

    def test_calc1
    end
end
