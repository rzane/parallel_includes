ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'parallel_includes_dev'
)

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :things, force: true do |t|
    t.belongs_to :one
    t.belongs_to :two
    t.belongs_to :three
    t.belongs_to :four
    t.belongs_to :five
    t.belongs_to :six
  end

  create_table :big_guys, force: true

  %w(ones twos threes fours fives sixes).each do |name|
    create_table name, force: true do |t|
      t.belongs_to :big_guy
    end
  end
end

class Thing < ActiveRecord::Base
  belongs_to :one
  belongs_to :two
  belongs_to :three
  belongs_to :four
  belongs_to :five
  belongs_to :six

  ASSOCIATIONS = reflections.keys.map(&:to_sym)

  def self.create_with_associations!
    pairs = reflections.map do |name, refl|
      [name.to_sym, refl.klass.create!]
    end

    create! pairs.to_h
  end
end

class BigGuy < ActiveRecord::Base
  has_many :ones
  has_many :twos
  has_many :threes
  has_many :fours
  has_many :fives, class_name: 'Five' # wtf?
  has_many :sixes

  ASSOCIATIONS = reflections.keys.map(&:to_sym)

  def self.create_with_associations!(num: 3)
    pairs = reflections.map do |name, refl|
      [name.to_sym, num.times.map { refl.klass.create! }]
    end

    create! pairs.to_h
  end
end

class One < ActiveRecord::Base; end
class Two < ActiveRecord::Base; end
class Three < ActiveRecord::Base; end
class Four < ActiveRecord::Base; end
class Five < ActiveRecord::Base; end
class Six < ActiveRecord::Base; end
