defmodule ChatbotWeb.PageController do
  use ChatbotWeb, :controller
  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
