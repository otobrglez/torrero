# Torrero

Ultra-massive [Tor](https://www.torproject.org)-based Ruby scraper. Proof-of-concept!

Inspired by [Tor](https://www.torproject.org) architecture, this project provides experimental framework and foundation for building massive scraper infrastructure for anonymous scraping. Torrero tries to solve problem of scraping on massive scale.

## Usage

1. Clone the project

    ```
    git clone https://github.com/otobrglez/torrero.git
    cd torrero
    ```

2. Start a few Tor instances with [god](http://godrb.com/). Example with 4 tors:

    ```
    NUM_OF_TORS=4 god -c tor.god -D
    ```

3. Start [Redis](http://redis.io) with [Foreman](http://ddollar.github.io/foreman/).

    ```
    foreman start -f Procfile.development
    ```

## Requirements

- [Tor](https://www.torproject.org) - for anonymous browsing.
- [Privoxy](http://www.privoxy.org) - for proxying request.
- [Redis](https://www.rabbitmq.com) - for messaging and queuing of requests.
- [MongoDB](https://www.mongodb.org) - for response storage.

## Contributions && License

This project is under [LGPL](https://www.gnu.org/licenses/lgpl.html) you can do whatever you want with it. Contributions are more than welcome. Thanks!

## Author

- [Oto Brglez](https://github.com/otobrglez)

