# Torrero

Ultra-massive [Tor](https://www.torproject.org)-based Ruby scraper. Proof-of-concept!

Inspired by [Tor](https://www.torproject.org) architecture, this project provides experimental framework and foundation for building massive scraper infrastructure for anonymous scraping. Torrero tries to solve problem of scraping on massive scale.

## Usage

1. Start a few Tor's up with [God](http://godrb.com/). 4 for example...

    NUM_OF_TORS=4 god -c tor.god -D

2. Start [RabbitMQ](https://www.rabbitmq.com) and [MongoDB](https://www.mongodb.org) with [Foreman](http://ddollar.github.io/foreman/).

    foreman start -f Procfile.development

## Requirements

- [Tor](https://www.torproject.org) - for anonymous "browsing"
- [RabbitMQ](https://www.rabbitmq.com) - for messaging and queuing of requests
- [MongoDB](https://www.mongodb.org) - for response storage

## Contributions && License

This project is under [LGPL](https://www.gnu.org/licenses/lgpl.html) you can do whatever you want with it. Contributions are more than welcome. Thanks!

## Author

- [Oto Brglez](https://github.com/otobrglez)

