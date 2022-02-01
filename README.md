# Chatbot CoinGecko

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  * To generate docs run `mix docs`
  * To open documentation run `open open doc/index.html`
  * To run test type `mix test` 

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Commands

  * `change-name :newname`
  * `search-by-name :name`
  * `search-by-id :id`
  * `coin-price :id`

## Main Chatbot Feature
The main chatbot feature allows multiple users to chat at the same time. It shows instantly when the user joins and leaves. 

Users currently in the chatroom are displayed in the right user panel list.

![](/priv/static/images/chatbot-main.png)


## Change Username
By typing the command `change-name :azhad` username is updated to `azhad`

![](/priv/static/images/change-name.png)


## Search for coins by name
By typing the command `search-by-name :bit` list of 5 coins are displayed to the user

![](/priv/static/images/search-coin.png)

## Search for coins by id/key
By typing the command `search-by-id :filecoin` details of the coin details are shown.

![](/priv/static/images/search-id.png)

## Retrieve coin market price by id/key
By typing the command `coin-price :filecoin` details of the coin market price for the last 14 days in USD are shown.

![](/priv/static/images/market-price.png)

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
