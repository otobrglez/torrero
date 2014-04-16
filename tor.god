CONTROL_PORT=8118
SOCKS_PORT=9050

God.pid_file_directory = 'tmp'

(0..2).to_a.each_with_index do |i|
  God.watch do |w|
    w.name = "tor-#{i}"

    w.log = File.open(File.join(Dir.pwd, "/log/tor-#{i}.log"), File::WRONLY|File::CREAT|File::EXCL)
    w.start = "tor --CookieAuthentication 0 --HashedControlPassword \"\" --ControlPort #{(CONTROL_PORT+i)} --SocksPort #{(SOCKS_PORT+i)} --DataDirectory tmp/tor-#{i}"

    w.keepalive
  end
end
