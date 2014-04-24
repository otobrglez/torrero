require 'ostruct'

class Torrero::Fetch
  attr_accessor :url, :method

  def initialize url, method: "GET"
    @url = url
    @method = method
  end

  def to_json *a
    {
      class: self.class.name,
      data: {
        url: @url,
        method: @method
      }
    }.to_json(*a)
  end

  def self.json_create(o)
    new(o["data"]["url"], method: o["data"]["method"])
  end

end

