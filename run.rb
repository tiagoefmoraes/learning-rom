require 'bundler'
Bundler.setup

require 'ostruct'
require 'rom-csv'
require 'rom-yaml'
require 'rom-repository'
require 'rom/plugins/relation/view'
require 'rom/plugins/relation/key_inference'

module ROMCSV
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

  def self.build_container(csv_file)
    env = ROM::Environment.new
    env.setup(:csv, csv_file)
    env.register_relation(Users)
    env.finalize.container
  end
end

module ROMYAML
  class Users < ROM::Relation[:yaml]
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

  def self.build_container(yml_file)
    env = ROM::Environment.new
    env.setup(:yaml, yml_file)
    env.register_relation(Users)
    env.finalize.container
  end
end


class User < OpenStruct
end

class UserRepository < ROM::Repository::Base
 relations :users

 def get(id)
   users.as(User).by_id(id).one!
 end

end

csv_repo = UserRepository.new(ROMCSV.build_container('users.csv'))

puts csv_repo.get(1)

yaml_repo = UserRepository.new(ROMYAML.build_container('users.yml'))

puts yaml_repo.get(1)