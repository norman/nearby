# encoding: utf-8
require File.dirname(__FILE__) + '/test_helper.rb'

class TestNearby < Test::Unit::TestCase
  
  DB = File.dirname(__FILE__) + "/test.db"

  def setup
    Nearby::Database::create(DB, File.dirname(__FILE__) + "/fixtures/cities.txt")
  end
  
  def teardown
    FileUtils.rm_rf(DB)
  end
  
  def test_can_create_a_database
    assert File.exists?(DB)
  end

  def test_can_open_database
    assert Nearby::Database.new(DB)
  end
  
  def test_can_get_place
    nb = Nearby::Database.new(DB)
    assert_equal 1, nb.get_place(:name => "Ordino").length
  end

  def test_get_place_returns_empty_array_when_nothing_matches
    nb = Nearby::Database.new(DB)
    assert_equal 0, nb.get_place(:name => "fdsfdfdsfds").length
  end
  
  def test_can_get_place_with_alternate_name
    nb = Nearby::Database.new(DB)
    assert_equal 1, nb.get_place(:name => "Ордино").length
  end
  
  def test_can_get_nearby_places
    nb = Nearby::Database.new(DB)
    place = nb.get_place(:name => "Ordino")
    assert_equal 6, nb.get_nearby(place.first, 10).length
  end


end
