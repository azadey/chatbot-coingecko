defmodule ChatbotWeb.Coin do
  defstruct [
    :id, :name, :symbol, :categories, :public_notice, :description, :image,
    :sentiment_votes_up_percentage, :sentiment_votes_down_percentage, :market_cap_rank, :coingecko_rank,
    :coingecko_score, :developer_score, :community_score, :liquidity_score, :public_interest_score,
    :market_data
  ]

  def from(%{
    "id" => id,
    "name" => name,
    "symbol" => symbol,
    "categories" => categories,
    "public_notice" => public_notice,
    "description" => description,
    "image" => image,
    "sentiment_votes_up_percentage" => sentiment_votes_up_percentage,
    "sentiment_votes_down_percentage" => sentiment_votes_down_percentage,
    "market_cap_rank" => market_cap_rank,
    "coingecko_rank" => coingecko_rank,
    "coingecko_score" => coingecko_score,
    "developer_score" => developer_score,
    "community_score" => community_score,
    "liquidity_score" => liquidity_score,
    "public_interest_score" => public_interest_score,
    "market_data" => market_data
  }) do
    %__MODULE__{
      id: id,
      name: name,
      symbol: symbol,
      categories: categories,
      public_notice: public_notice,
      description: description,
      image: image,
      sentiment_votes_up_percentage: sentiment_votes_up_percentage,
      sentiment_votes_down_percentage: sentiment_votes_down_percentage,
      market_cap_rank: market_cap_rank,
      coingecko_rank: coingecko_rank,
      coingecko_score: coingecko_score,
      developer_score: developer_score,
      community_score: community_score,
      liquidity_score: liquidity_score,
      public_interest_score: public_interest_score,
      market_data: market_data
    }
  end
end
