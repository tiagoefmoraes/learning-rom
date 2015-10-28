require 'bundler'
Bundler.setup

require 'rom-repository'

env = ROM::Environment.new
env.setup(:csv, 'users.csv')

class Users < ROM::Relation[:csv]
  view(:base, [:id, :name]) do
    self
  end

  def by_id(id)
    restrict(id: id)
  end
end

env.register_relation(Users)

rom = env.finalize.container

p rom.relation(:users).by_id(1).one
