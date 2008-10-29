require 'test/unit'

require 'rubygems'
require 'redgreen' unless ENV['TM_MODE']
require 'shoulda'
require 'mocha'

$: << File.dirname(__FILE__) + "/../lib"
require 'weewar-spy'

module XmlFixtures
  def load_fixture(name)
    File.open(File.join(File.dirname(__FILE__), %W[fixtures #{name}.xml]))
  end
end

# File lib/shoulda/assertions.rb, line 7
def assert_same_elements(a1, a2, msg = nil)
  [:select, :inject, :size].each do |m|
    [a1, a2].each {|a| assert_respond_to(a, m, "Are you sure that #{a.inspect} is an array?  It doesn't respond to #{m}.") }
  end

  assert a1h = a1.inject({}) { |h,e| h[e] = a1.select { |i| i == e }.size; h }
  assert a2h = a2.inject({}) { |h,e| h[e] = a2.select { |i| i == e }.size; h }

  assert_equal(a1h, a2h, msg)
end
