#!/usr/bin/env ruby

require 'bundler/setup'
require 'thread'

Thread.abort_on_exception = true

class SimpleWorker
	def run
		while 1 != 2 do
			puts "Ellow at #{DateTime.now}"
			sleep 2
		end
	end
end

t = Thread.new { SimpleWorker.new.run }
t.join
