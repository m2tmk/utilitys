require 'test_helper'

class InterestCalclatorTest < ActiveSupport::TestCase
  test "when not leap year" do
    interest = Calculator::Interest.calc(10000000, 2.7, Date.new(2013,1,11), Date.new(2013,3,9))
    assert_equal 42163, interest
  end
end