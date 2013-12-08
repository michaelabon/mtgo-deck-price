# MTGO Deck Price

Solving the question, "How can I trade you money for things?"

Want to find out how much a deck costs on MTGO? Tired of typing in
card-by-card, wishing that someone would just let you paste in your deck file?
Now you can.

## Installation

You need Ruby 1.9 to make this work.

After cloning:

```ruby
bundle install
```

This covers all the requirements.

## Usage

Paste your deck list in to the source code at the top. Can't miss it.

```bash
ruby mtgodeckprice.rb
```

## Output

1. Each card will be printed as it is received.
2. Then, the list sorted by price will be shown.
3. Finally, the total deck list.

## Comments

I prefer MTGOTraders. That's the store this script queries.

I don't want to overload MTGOTraders' site, so I have a random wait of 1-3
seconds after each card. A full Commander deck will take 3 minutes. Deal with
it. It's called being polite. Better than typing them in manually. 

## Alternatives

Best alternative solution is to go inside MTGO, open up trade with a bot,
submit your decklist as a wishlist, and see how many tickets it'll cost you.
The problem with this is that you have no guarantee that the bot has all the
cards you are requesting (unless you check the trade manually).
