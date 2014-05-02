#!/usr/bin/env ruby
require 'net/http'
require 'openssl'
require 'ostruct'
require 'benchmark'
require 'csv'

class Report < OpenStruct
  def self.report_for request_url
    start = Time.now

    begin
      proxy_uri = URI('http://torrero-main:3113')
      uri = URI(request_url)

      http = Net::HTTP.new(uri.path)

      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      proxy = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port)
      http = proxy.start(uri.host, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE)

      resp = http.get(uri.path)

      Report.new({
        time: (Time.now - start),
        code: resp.code.to_i,
        response: "OK"
      })
    rescue
      Report.new({
        time: (Time.now - start),
        code: 500,
        response: "ERROR"
      })
    end
  end
end

if ARGV[0].nil?
  $stderr.puts "Missing output file!"
  exit(1)
end

TIMES=100
CSV.open(ARGV[0], "wb", {force_quotes: true, col_sep:"\t"}) do |csv|

  TIMES.times do |i|
    key = "KIK-1"
    report = Report.report_for("https://www.kickstarter.com/discover?ref=nav")
    puts "GOT: %s - %d - %d - %s" % [key, i, report.code, report.response]
    csv << [key, i, report.time, report.code, report.response]
  end

  TIMES.times do |i|
    key = "KIK-2"
    report = Report.report_for("https://www.kickstarter.com/discover/places/london-gb?ref=city")

    puts "GOT: %s - %d - %d - %s" % [key, i, report.code, report.response]
    csv << [key, i, report.time, report.code, report.response]
  end

  TIMES.times do |i|
    key = "SO"
    report = Report.report_for("http://stackoverflow.com/questions/tagged/ruby")

    puts "GOT: %s - %d - %d - %s" % [key, i, report.code, report.response]
    csv << [key, i, report.time, report.code, report.response]
  end

end # /CSV

