require 'delegate'

module GildedRose
  AGED_BRIE      = 'Aged Brie'
  BACKSTAGE_PASS = 'Backstage passes to a TAFKAL80ETC concert'
  CONJURED       = 'Conjured'
  SULFURAS       = 'Sulfuras, Hand of Ragnaros'

  class ItemUpdater < SimpleDelegator
    def quality=(quality)
      super(quality.clamp(0, 50))
    end

    def call
      age
      change_quality
    end

  private

    def expired?
      sell_in.negative?
    end

    def age
      self.sell_in -= 1
    end

    def change_quality
      self.quality += value_change
    end

    def value_change
      expired? ? -2 : -1
    end
  end

  class AgedBrieUpdater < ItemUpdater
    def value_change
      -super()
    end
  end

  class BackspacePassUpdater < ItemUpdater
    def value_change
      if expired?
        -quality
      elsif sell_in < 5
        3
      elsif sell_in < 10
        2
      else
        1
      end
    end
  end

  class ConjuredUpdater < ItemUpdater
    def value_change
      super() * 2
    end
  end

  class SulfurasUpdater < ItemUpdater
    def age
      # do nothing
    end

    def change_quality
      # do nothing
    end
  end

  UPDATERS = [
    [AGED_BRIE,         AgedBrieUpdater],
    [BACKSTAGE_PASS,    BackspacePassUpdater],
    [SULFURAS,          SulfurasUpdater],
    [/\A#{CONJURED}\b/, ConjuredUpdater],
    [proc { true },     ItemUpdater]
  ]

  def self.update_quality(items)
    items.each do |item|
      _matcher, klass = UPDATERS.detect { |matcher, _klass| matcher === item.name }
      klass.new(item).call
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

