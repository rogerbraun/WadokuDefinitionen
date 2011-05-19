require "rubygems"
require "bundler"

Bundler.require 

task :fill_database do

  require "./models/user.rb"
  require "./models/definition.rb"
  require "./config/db.rb"
  
  import_file = open("JWD.tab").read

  Definition.fill import_file 

end
