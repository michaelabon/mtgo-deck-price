#!/usr/bin/env ruby

require 'colored'
require 'mechanize'
require 'pp'

class Card
  include Comparable
  attr_accessor :product, :price, :qty

  def initialize(product, price, qty)
    @product = product.text.strip.gsub("\u00A0", "")
    @price = Float(price.text.strip[1..-1]) # remove leading $
    @qty = Integer(qty.text.strip)
  end

  def <=>(other)
    [price, product, qty] <=> [other.price, other.product, other.qty]
  end

  def to_s
    "#{product} @ $#{price}"
  end
end

cards = [
  "Anger",
  "Bend or Break",
  "Bind",
  "Blasphemous Act",
  "Blood Moon",
  "Boom/Bust",
  "Chameleon Colossus",
  "Compost",
  "Creeping Corrosion",
  "Cultivate",
  "Decree of Annihilation",
  "Destructive Force",
  "Detritivore",
  "Deus of Calamity",
  "Dragon Broodmother",
  "Explore",
  "Explosive Vegetation",
  "Fires of Yavimaya",
  "Forest",
  "Garruk Wildspeaker",
  "Garruk's Packleader",
  "Greater Gargadon",
  "Green Sun's Zenith",
  "Harmonize",
  "Heartless Hidetsugu",
  "Holistic Wisdom",
  "Hull Breach",
  "Hunter's Insight",
  "Hydra Omnivore",
  "In the Web of War",
  "Instigator Gang",
  "Into the Core",
  "Keldon Firebombers",
  "Kodama's Reach",
  "Krosan Grip",
  "Magus of the Moon",
  "Markov Blademaster",
  "Momentous Fall",
  "Mountain",
  "Multani, Maro-Sorcerer",
  "Natural Balance",
  "Nature's Will",
  "Nostalgic Dreams",
  "Price of Glory",
  "Primal Order",
  "Reforge the Soul",
  "Regrowth",
  "Restock",
  "Ruination",
  "Rumbling Slum",
  "Sarkhan Vol",
  "Scavenging Ooze",
  "Seedguide Ash",
  "Soul's Majesty",
  "Spawnwrithe",
  "Stranglehold",
  "Taurean Mauler",
  "Tectonic Break",
  "Terravore",
  "Thoughts of Ruin",
  "Urabrask the Hidden",
  "Viashino Heretic",
  "Wheel of Fortune",
  "Wildfire",
  "Zo-Zu the Punisher",
]

url = 'http://www.mtgotraders.com'
hidden_key = 'storeid'
text_key = 'search_field'

@results = []

cards.each do |card|
  a = Mechanize.new
  a.get(url) do |page|
    card_result = page.form_with(:action => /productsearch\.cgi/) do |search|
      search[text_key] = card
    end.submit

    title_skipped = false

    card_prices = card_result.parser.xpath("//table[@width=\"650\"]/tr").collect do |row|
      unless title_skipped
        title_skipped = true
        next nil
      end

      if row.at("td[1]").attr('colspan') # This row is for a set name
        nil
      elsif row.at("td[6]") == nil # This row is for a foil card
        Card.new(
          row.at("td[1]"),
          row.at("td[2]"),
          row.at("td[3]"),
        )
      else
        Card.new(
          row.at("td[3]"),
          row.at("td[4]"),
          row.at("td[5]"),
        )
      end
    end

    sleep (rand * 2) + 1

    card_prices.delete_if {|x| x == nil || x.qty == 0}

    puts card_prices.min

    @results << card_prices.min
  end
end

@results.sort!
pp @results

print "Total price : "

total = @results.reduce(0.0) { |sum, card| sum + card.price }

puts " $#{total}"
