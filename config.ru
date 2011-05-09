require "rubygems"
require "bundler"

Bundler.require
require "sinatra/reloader" if development?


require "./app.rb"

run Sinatra::Application
