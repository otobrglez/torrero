require 'bundler/setup'


ENV["TORRERO_ENV"] ||="development"

require_relative "../config/#{ENV['TORRERO_ENV']}" if File.exist? "../config/#{ENV['TORRERO_ENV']}"
