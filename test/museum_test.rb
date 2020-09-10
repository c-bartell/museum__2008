require 'minitest/autorun'
require 'minitest/pride'
require './lib/museum'
require './lib/exhibit'
require './lib/patron'

class MuseumTest < Minitest::Test
  def setup
    @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    @imax = Exhibit.new({name: "IMAX",cost: 15})
    @patron_1 = Patron.new("Bob", 20)
    @patron_2 = Patron.new("Sally", 20)
    @patron_3 = Patron.new("Johnny", 5)
  end

  def test_it_has_attributes
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal "Denver Museum of Nature and Science", dmns.name
    assert_equal [], dmns.exhibits
  end

  def test_it_can_add_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal [], dmns.exhibits

    dmns.add_exhibit(@gems_and_minerals)
    dmns.add_exhibit(@dead_sea_scrolls)
    dmns.add_exhibit(@imax)

    assert_equal [@gems_and_minerals, @dead_sea_scrolls, @imax], dmns.exhibits
  end

  def test_can_recommend_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")
    dmns.add_exhibit(@gems_and_minerals)
    dmns.add_exhibit(@dead_sea_scrolls)
    dmns.add_exhibit(@imax)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("IMAX")
    actual = dmns.recommend_exhibits(@patron_1)
    expected = [@gems_and_minerals, @dead_sea_scrolls]

    assert_equal expected, actual

    actual = dmns.recommend_exhibits(@patron_2)
    expected = [@imax]

    assert_equal expected, actual
  end

  def test_it_can_admit_patrons
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal [], dmns.patrons

    dmns.admit(@patron_1)
    dmns.admit(@patron_2)
    dmns.admit(@patron_3)

    assert_equal [@patron_1, @patron_2, @patron_3], dmns.patrons
  end
end
