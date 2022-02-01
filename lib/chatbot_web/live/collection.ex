defmodule ChatbotWeb.Collection do
  defstruct [
    :id, :name, :symbol, :market_cap_rank, :thumb, :large
  ]

  def from(%{
    "id" => id,
    "name" => name,
    "symbol" => symbol,
    "market_cap_rank" => market_cap_rank,
    "thumb" => thumb,
    "large" => large
  }) do
    %__MODULE__{
      id: id,
      name: name,
      symbol: symbol,
      market_cap_rank: market_cap_rank,
      thumb: thumb,
      large: large
    }
  end
end
