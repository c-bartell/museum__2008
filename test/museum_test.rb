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

  def test_it_can_categorize_patrons_by_interest
    dmns = Museum.new("Denver Museum of Nature and Science")
    dmns.add_exhibit(@gems_and_minerals)
    dmns.add_exhibit(@dead_sea_scrolls)
    dmns.add_exhibit(@imax)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    dmns.admit(@patron_1)
    dmns.admit(@patron_2)
    dmns.admit(@patron_3)

    expected = {
      @gems_and_minerals => [@patron_1],
      @dead_sea_scrolls => [@patron_1, @patron_2, @patron_3],
      @imax => []
    }
    actual = dmns.patrons_by_exhibit_interest

    assert_equal expected, actual
  end

  def test_it_can_generate_lottery_contestants
    dmns = Museum.new("Denver Museum of Nature and Science")
    dmns.add_exhibit(@gems_and_minerals)
    dmns.add_exhibit(@dead_sea_scrolls)
    dmns.add_exhibit(@imax)
    @patron_1 = Patron.new("Bob", 0)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    dmns.admit(@patron_1)
    dmns.admit(@patron_2)
    dmns.admit(@patron_3)
    expected = [@patron_1, @patron_3]
    actual = dmns.ticket_lottery_contestants(@dead_sea_scrolls)

    assert_equal expected, actual
  end

  def test_it_can_draw_a_lottery_winner
    dmns = Museum.new("Denver Museum of Nature and Science")
    dmns.add_exhibit(@gems_and_minerals)
    dmns.add_exhibit(@dead_sea_scrolls)
    dmns.add_exhibit(@imax)
    @patron_1 = Patron.new("Bob", 0)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    dmns.admit(@patron_1)
    dmns.admit(@patron_2)
    dmns.admit(@patron_3)
    contestants = dmns.ticket_lottery_contestants(@dead_sea_scrolls)
    actual = dmns.draw_lottery_winner(@dead_sea_scrolls)

    assert contestants.map(&:name).include?(actual)

    actual = dmns.draw_lottery_winner(@gems_and_minerals)

    assert_nil actual
  end

  def test_it_can_announce_lottery_winner
    dmns = Museum.new("Denver Museum of Nature and Science")
    dmns.add_exhibit(@gems_and_minerals)
    dmns.add_exhibit(@dead_sea_scrolls)
    dmns.add_exhibit(@imax)
    @patron_1 = Patron.new("Bob", 0)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")

    dmns.admit(@patron_1)
    dmns.admit(@patron_2)
    dmns.admit(@patron_3)

    dmns.stubs(:sample).returns(@patron_1)

    expected = "Bob has won the IMAX exhibit lottery"
    actual = dmns.dmns.announce_lottery_winner(imax)
    assert_equal expected, actual
  end
end
