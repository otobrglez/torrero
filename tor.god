CONTROL_PORT = ENV["CONTROL_PORT"] || 8118
SOCKS_PORT = ENV["SOCKS_PORT"] || 9050
NUM_OF_TORS = ENV["NUM_OF_TORS"] || 3

God.pid_file_directory = 'tmp'

(0..(NUM_OF_TORS.to_i-1)).to_a.each_with_index do |i|
  God.watch do |w|
    w.name = "tor-#{i}"

    w.log = File.open(File.join(Dir.pwd, "/log/tor-#{i}.log"), "w+")
    w.start = "tor --CookieAuthentication 0 --HashedControlPassword \"\" --ControlPort #{(CONTROL_PORT+i)} --SocksPort #{(SOCKS_PORT+i)} --DataDirectory tmp/tor-#{i}"

    w.keepalive
  end
end
