#!/usr/bin/env ruby

require 'time'
require 'net/http'
require 'openssl'
require 'logger'

$logger = Logger.new(STDOUT)

def fetch(url,other_headers={})
  start = DateTime.now
  uri = URI.parse(url)

  http = Net::HTTP.new(uri.host, uri.port)
  http.read_timeout = 300

  if uri.scheme == 'https'
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  headers = {
    "User-Agent" => "Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Firefox/31.0"
  }.merge(other_headers)

  request = Net::HTTP::Get.new uri.request_uri, headers

  if ENV["KICKTRACE_PROXY"]
    proxy_uri = URI(ENV["KICKTRACE_PROXY"])
    proxy = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port)
    http = proxy.start(uri.host, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE)
  end

  output = http.request request

  completed = '%.3f' % ((DateTime.now - start) * 24 * 60 * 60).to_f
	
	$logger.info("Completed in #{completed}")

  case output
  when Net::HTTPSuccess, Net::HTTPRedirection then
    "OK"
  when Net::HTTPFatalError
    "FAIL"
  else
    "OTHER"
  end
rescue Net::HTTPFatalError
  "FAIL"
end

output = {"OK" => 0, "FAIL" => 0, "OTHER" => 0}
1000.times do |t|
  value = fetch(ENV["URL"] || "http://icanhazip.com/")
	$logger.info("Completed with #{value}")
  output[value] += 1
end

puts output


