require 'minitest/spec'
require 'minitest/pride'
require 'minitest/mock'
require 'minitest/autorun'
require 'ostruct'
require 'rr'

class MiniTest::Spec
  include RR::Adapters::RRMethods
end
