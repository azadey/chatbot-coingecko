defmodule ChatbotWeb.CoinGecko do
  @moduledoc """
    Helper method to make request to CoinGecko API
  """

  @client Application.get_env(:coingecko, :client) || ChatbotWeb.Client

  @doc """
    Send a request to ping endpoint to check GeckoAPI is working

  ## Examples

        iex> ChatbotWeb.CoinGecko.ping()
        {:ok,
          %{"gecko_says" => "(V3) To the Moon!"}
        }
  """
  def ping() do
    with {:ok, response} <- @client.get("ping") do
        {:ok, response}
    else
      error -> error
    end
  end

  @doc """
    Get coins matching given search parameter. The `query` parameter indicates the search string.

  ## Examples

        iex> {status, _response} = ChatbotWeb.CoinGecko.search(%{query: "bit"})
        iex> status
        :ok
  """
  def search(query) do
    with {:ok, response} <- @client.get("search", query) do
      coins =
        response
        |> Map.get("coins")
        |> Enum.take(5)
        |> Enum.map(fn(coin) ->
          ChatbotWeb.Collection.from(coin)
        end)

      {:ok, coins}
    else
      error -> error
    end
  end

  @doc """
    Get details for a single coin

  ## Examples

      iex> {status, _response} = ChatbotWeb.CoinGecko.coin("filecoin")
      iex> status
      :ok
  """
  def coin(key) do
    with {:ok, response} <- @client.get("coins/#{key}") do
      collection = ChatbotWeb.Coin.from(response)
      {:ok, collection}
    else
      error -> error
    end
  end

  @doc """
    Get the market prices for a given id parmas `vs_currency: usd` and `days:14`

  ## Examples
      iex> {status, _response} = ChatbotWeb.CoinGecko.coinMarketChart("filecoin")
      iex> status
      :ok
  """
  def coinMarketChart(key) do
    with {:ok, response} <-  @client.get("coins/#{key}/market_chart", %{vs_currency: "usd", days: 14}) do
      priceCollection =ChatbotWeb.PriceCollection.from(response)
      {:ok, priceCollection}
    else
      error -> error
    end
  end

end
