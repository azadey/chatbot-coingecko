defmodule ChatbotWeb.PageControllerTest do
  use ChatbotWeb.ConnCase
  doctest ChatbotWeb.CoinGecko

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert conn.status == 200
  end
end
