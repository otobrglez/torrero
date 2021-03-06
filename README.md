# Torrero

Ultra-massive [Tor](tor)-based HA proxy. Build for anonymous scraping on large scale. Proof-of-concept!

Inspired by [Tor][tor], this project provides experimental framework / architecture and foundation for building infrastructure for massive anonymous scraping.

![torrero-demo][torrero-demo]

- [Oto Brglez](http://github.com/otobrglez)

## Usage

Starts 10 [Tor][tor] deamons, 10 [Privoxy][privoxy] instances and [HAProxy][haproxy], all pre-configured and ready to use!

    NUMBER_OF_TORS=10 mina torrero:start

Point your client to server, port 3113...

    curl --proxy torrero-main:3113 http://icanhazip.com/

## Mina tasks for managements

    mina setup                              # Setup infrastructure on your server

    NUMBER_OF_TORS=10 mina torrero:start    # Starts 10 Tors, 10 privoxys and 1 HAProxy
    mina torrero:stop                       # Stop everything

    mina tor:start_all                      # Start Tors
    mina tor:stop_all                       # Stop Tors
    mina tor:config                         # Dump configuration
    mina tor:logs                           # Cat logs from Tors

    mina haproxy:start                      # Start HAProxy
    mina haproxy:stop                       # Stop HAProxy
    mina haproxy:update                     # Update HAProxy configuration for Tors
    mina haproxy:config                     # Dump configuration

## Requirements

- [Tor][tor] - Anonymity network client
- [HAProxy][haproxy] - High Performance TCP/HTTP Load Balancer
- [Monit][monit] - Monit - utility for monitoring services on a Unix system
- [Privoxy][privoxy] - Privacy enhancing HTTP Proxy

## Packages on Ubuntu

    sudo apt-get install tor haproxy monit privoxy -y

## Monit

I also suggest that you use [Monit](http://mmonit.com/monit/) for monitoring all services. Configuration can be found in [config](config/monit.conf) folder.

## Benchmarking

    ab -X torrero-main:3113 -n 1000 -c 100 -v 2 http://icanhazip.com/
    ruby torrero_test.rb

## Contributions && License

This project is under [LGPL](https://www.gnu.org/licenses/lgpl.html) you can do whatever you want with it. Contributions are more than welcome. Thanks!

## Author

- [Oto Brglez](https://github.com/otobrglez)

[tor]:https://www.torproject.org
[foreman]:http://ddollar.github.io/foreman/
[privoxy]:http://www.privoxy.org
[redis]:https://www.rabbitmq.com
[mongodb]:https://www.mongodb.org
[haproxy]:http://haproxy.1wt.eu/
[torrero-demo]:torrero-demo.gif
[monit]:http://mmonit.com/monit/
[privoxy]:http://www.privoxy.org/
