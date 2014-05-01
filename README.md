# Torrero

Ultra-massive [Tor](tor)-based Ruby scraper. Proof-of-concept!

Inspired by [Tor](tor), this project provides experimental framework and architecture and foundation for building massive scraper infrastructure for anonymous scraping. Torrero tries to solve problem of scraping on massive scale.

## Usage

TODO: Write usage example here.

## Mina tasks for managements

    mina setup                       # Setup infrastructure on your server

    mina tor:start_all               # Start Tors
    mina tor:stop_all                # Stop Tors
    mina tor:config                  # Dump configuration
    mina tor:logs                    # Cat logs from Tors

    mina haproxy:start               # Start HAProxy
    mina haproxy:stop                # Stop HAProxy
    mina haproxy:update              # Update HAProxy configuration for Tors
    mina haproxy:config              # Dump configuration

## Requirements

- [Tor][tor] - Anonymity network
- [HAProxy][haproxy] - High Performance TCP/HTTP Load Balancer

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
