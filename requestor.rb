#!/usr/bin/env ruby
require_relative "./lib/boot"
require 'net/http'
require 'json'

URL = "http://icanhazip.com/"

fetch = Torrero::Fetch.new(URL)

puts fetch.to_json.to_s

puts JSON.parse(fetch.to_json.to_s)
