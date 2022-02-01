defmodule ChatbotWeb.PriceCollection do
  defstruct [
    :prices
  ]

  def from(%{
    "prices" => prices
  }) do
    %__MODULE__{
      prices: prices
    }
  end
end
