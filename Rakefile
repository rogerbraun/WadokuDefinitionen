require "rubygems"
require "bundler"

Bundler.require 

# Füllt die Definitionsdatenbank mit den Daten aus JWD.tab.
# Dauert lange! Es gibt etwa 400.000 Einträge.
task :fill_database do

  require "./models/user.rb"
  require "./models/definition.rb"
  require "./config/db.rb"
  
  import_file = open("JWD.tab").read

  Definition.fill import_file 

end

# Gibt jedem Benutzer 1000 neue Einträge für die er zuständig ist.
task :assign_definitions do

  require "./models/user.rb"
  require "./models/definition.rb"
  require "./config/db.rb"

  free_defs = Definition.all(:user_id => nil)
  i = 0
  User.all.each do |user|
    1.upto(1000) do
      defi = free_defs[i]
      defi.user = user
      defi.save 
      i += 1
    end
  end
end
