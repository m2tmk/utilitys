require 'rubygems'
require 'rspec'
require 'calculator'
require 'date'

describe Calculator::Interest, "#calc" do
    it "should 42,163 when price:10,000,000 rate:2.7 cutoff:27 from:2013/1/11 to:2013/3/9" do
        price = 10000000
        rate = 2.7
        cutoff = 27
        from = Date.new(2013,1,11)
        to = Date.new(2013,3,9)

        interest = Calculator::Interest.calc(price, rate, cutoff, from, to)
        interest.should == 42163
    end
end
