require 'delegate'

module GildedRose
  class ItemUpdater < SimpleDelegator
    def call
      if self.name != 'Aged Brie' && self.name != 'Backstage passes to a TAFKAL80ETC concert'
        if self.quality > 0
          if self.name != 'Sulfuras, Hand of Ragnaros'
            self.quality -= 1
          end
        end
      else
        if self.quality < 50
          self.quality += 1
          if self.name == 'Backstage passes to a TAFKAL80ETC concert'
            if self.sell_in < 11
              if self.quality < 50
                self.quality += 1
              end
            end
            if self.sell_in < 6
              if self.quality < 50
                self.quality += 1
              end
            end
          end
        end
      end
      if self.name != 'Sulfuras, Hand of Ragnaros'
        self.sell_in -= 1
      end
      if self.sell_in < 0
        if self.name != "Aged Brie"
          if self.name != 'Backstage passes to a TAFKAL80ETC concert'
            if self.quality > 0
              if self.name != 'Sulfuras, Hand of Ragnaros'
                self.quality -= 1
              end
            end
          else
            self.quality = self.quality - self.quality
          end
        else
          if self.quality < 50
            self.quality += 1
          end
        end
      end
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

