require 'delegate'

module GildedRose
  class ItemUpdater < SimpleDelegator
    def call
      if name != 'Aged Brie' && name != 'Backstage passes to a TAFKAL80ETC concert'
        if quality > 0
          if name != 'Sulfuras, Hand of Ragnaros'
            self.quality -= 1
          end
        end
      else
        if quality < 50
          self.quality += 1
          if name == 'Backstage passes to a TAFKAL80ETC concert'
            if sell_in < 11
              if quality < 50
                self.quality += 1
              end
            end
            if sell_in < 6
              if quality < 50
                self.quality += 1
              end
            end
          end
        end
      end
      if name != 'Sulfuras, Hand of Ragnaros'
        self.sell_in -= 1
      end
      if sell_in < 0
        if name != "Aged Brie"
          if name != 'Backstage passes to a TAFKAL80ETC concert'
            if quality > 0
              if name != 'Sulfuras, Hand of Ragnaros'
                self.quality -= 1
              end
            end
          else
            self.quality = quality - quality
          end
        else
          if quality < 50
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

