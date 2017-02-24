ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'parallel_includes_dev'
)

ActiveRecord::Schema.define do
  create_table :things, force: true do |t|
    t.belongs_to :one
    t.belongs_to :two
    t.belongs_to :three
    t.belongs_to :four
    t.belongs_to :five
    t.belongs_to :six
  end

  create_table :ones, force: true
  create_table :twos, force: true
  create_table :threes, force: true
  create_table :fours, force: true
  create_table :fives, force: true
  create_table :sixes, force: true
end

class Thing < ActiveRecord::Base
  belongs_to :one
  belongs_to :two
  belongs_to :three
  belongs_to :four
  belongs_to :five
  belongs_to :six
end

class One < ActiveRecord::Base; end
class Two < ActiveRecord::Base; end
class Three < ActiveRecord::Base; end
class Four < ActiveRecord::Base; end
class Five < ActiveRecord::Base; end
class Six < ActiveRecord::Base; end
