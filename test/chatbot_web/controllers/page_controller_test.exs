defmodule ChatbotWeb.PageControllerTest do
  use ChatbotWeb.ConnCase
  doctest ChatbotWeb.CoinGecko

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Phoenix in Action Chat"
  end
end
