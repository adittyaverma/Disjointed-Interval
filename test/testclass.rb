require_relative "../lib/main.rb"
require "test/unit"
require 'csv'

class TestClass < Test::Unit::TestCase
  
  def test_simple_case_one
    CSV.open("./executable/input_file.csv", "w") do |csv|
      csv << ["Action", "Start Interval", "End Interval"]
      csv << ["add", "1", "5"]
      csv << ["remove", "2", "3"]
      csv << ["add", "6", "8"]
    end
    obj = Main.new
    obj.process_data
    file = File.open("./executable/output_file.txt")
  	assert_equal(file.read.split("\n").last.strip, "[[1, 2], [3, 5], [6, 8]]")
    file.close()
  end

  def test_remove_outside_interval
    CSV.open("./executable/input_file.csv", "w") do |csv|
      csv << ["Action", "Start Interval", "End Interval"]
      csv << ["add", "1", "5"]
      csv << ["remove", "7", "8"]
      csv << ["add", "6", "8"]
    end
    obj = Main.new
    obj.process_data
    file = File.open("./executable/output_file.txt")
    assert_equal(file.read.split("\n").last.strip, "[[1, 5], [6, 8]]")
    file.close()
  end

  def test_remove_from_blank
    CSV.open("./executable/input_file.csv", "w") do |csv|
      csv << ["Action", "Start Interval", "End Interval"]
      csv << ["remove", "7", "8"]
    end
    obj = Main.new
    obj.process_data
    file = File.open("./executable/output_file.txt")
    assert_equal(file.read.split("\n").last.strip, "[]")
    file.close()
  end
  
end
