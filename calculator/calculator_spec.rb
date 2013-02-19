require 'rubygems'
require 'rspec'
require 'date'
require_relative 'calculator'

describe Calculator::Interest, "#calc" do
    it "should 42163 when price:10000000 rate:0.027 from:2013/1/11 to:2013/3/9" do
        price = 10000000
        rate = 0.027
        from = Date.new(2013,1,11)
        to = Date.new(2013,3,9)

        interest = Calculator::Interest.calc(price, rate, from, to)
        interest.should == 42164
    end
end
