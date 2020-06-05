require 'delegate'

module GildedRose
  class ItemUpdater < SimpleDelegator
    def quality=(quality)
      super(quality.clamp(0, 50))
    end

    def call
      if name != 'Sulfuras, Hand of Ragnaros'
        self.sell_in -= 1
      end
      if name == 'Aged Brie'
        self.quality += 1
      elsif name == 'Backstage passes to a TAFKAL80ETC concert'
        self.quality +=
          if expired?
            -quality
          elsif sell_in < 5
            3
          elsif sell_in < 10
            2
          else
            1
          end
      elsif name != 'Sulfuras, Hand of Ragnaros'
        self.quality -= 1
        self.quality -= 1 if expired?
      end
      if expired?
        if name == "Aged Brie"
          self.quality += 1
        end
      end
    end

  private

    def expired?
      sell_in.negative?
    end
  end

  def self.update_quality(items)
    items.each do |item|
      ItemUpdater.new(item).call
    end
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

