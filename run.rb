require 'bundler'
Bundler.setup

require 'ostruct'
require 'rom-csv'
require 'rom-repository'
require 'rom/plugins/relation/view'
require 'rom/plugins/relation/key_inference'

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

env = ROM::Environment.new
env.setup(:csv, 'users.csv')
env.register_relation(Users)

rom = env.finalize.container

p rom.relation(:users).by_id(1).one




class User < OpenStruct
end

class UserRepository < ROM::Repository::Base
 relations :users

 def get(id)
   users.as(User).by_id(id).one!
 end

end

repo = UserRepository.new(rom)

puts repo.get(1)