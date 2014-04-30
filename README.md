# Torrero

Ultra-massive [Tor](tor)-based Ruby scraper. Proof-of-concept!

Inspired by [Tor](tor), this project provides experimental framework and architecture and foundation for building massive scraper infrastructure for anonymous scraping. Torrero tries to solve problem of scraping on massive scale.

## Usage

1. Clone the project

    ```
    git clone https://github.com/otobrglez/torrero.git
    cd torrero
    ```

2. Start a few Tor instances with [foreman](foreman). Example with 4 tors:

    ```
    foreman start -c tor=4
    ```

## Requirements

- [Tor](tor) - Tor - anonymity_network
- [HAProxy](haproxy) - Reliable, high performance TCP/HTTP load balancer

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
