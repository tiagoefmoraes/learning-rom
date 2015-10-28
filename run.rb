require 'bundler'
Bundler.setup

require 'rom-repository'
require 'rom/plugins/relation/view'
require 'rom/plugins/relation/key_inference'

env = ROM::Environment.new
env.setup(:csv, 'users.csv')

class Users < ROM::Relation[:csv]
  dataset :users

  use :view
  use :key_inference

  def primary_key
    :id
  end

  view(:base, [:id, :name, :email]) do
    self
  end

  def by_id(id)
    restrict(id: id)
  end
end

env.register_relation(Users)

rom = env.finalize.container

p rom.relation(:users).by_id(1).one







class UserRepository < ROM::Repository::Base
 relations :users

 def get(id)
   users.by_id(id)
 end

end

repo = UserRepository.new(rom)

puts repo.get(1)