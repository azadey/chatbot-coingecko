defmodule ChatbotWeb.Client do
  require Logger
  @callback get(String.t) :: {:ok, map} | {:error, map}
  @callback get(String.t, list) :: {:ok, map} | {:error, map}

  @http_client Application.get_env(:coingecko, :http_client) || HTTPoison

  def get(path, parameters \\ []) do
    Logger.info(path)
    case @http_client.get(uri(path), headers(), options(parameters)) do
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        case status < 300 do
          true -> {:ok, Poison.decode!(body)}
          false -> {:error, Poison.decode!(body)}
        end
      _ -> {:error, :unexpected_error}
    end
  end

  defp uri(path) do
    api_uri()
    |> URI.merge(path)
    |> URI.to_string()
  end

  defp headers() do
    [
      {"Accept", "application/json"}
    ]
  end

  defp options(parameters) do
    query_params = build_query_params(parameters)

    [
      params: query_params
    ]
  end

  defp build_query_params(parameters) do
    parameters
    |> Enum.filter(fn {_, v} -> v != nil && v != "" end)
  end

  defp api_uri, do: "https://api.coingecko.com/api/v3/"
end
