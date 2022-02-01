defmodule ChatbotWeb.RoomLive do
  use ChatbotWeb, :live_view
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:" <> room_id
    username = MnemonicSlugs.generate_slug(1)

    if connected?(socket) do
      ChatbotWeb.Endpoint.subscribe(topic)
      ChatbotWeb.Presence.track(self(), topic, username, %{})
    end

    {:ok, assign(socket,
        room_id: room_id,
        topic: topic,
        username: username,
        message: "",
        messages: [
          %{type: :welcome, uuid: UUID.uuid4(), username: username}
        ],
        user_list: [],
        temporary_assigns: [messages: []]
    )}
  end

  @impl true
  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do

    message = cond do
      String.contains?(message, "change-name") ->
        {start, _end} = :binary.match(message, ":")
        useratom = String.slice(message, start+1, String.length(message))
        %{uuid: UUID.uuid4(), content: "Username updated", username: useratom}
      String.contains?(message, "search-by-name") ->
        {start, _end} = :binary.match(message, ":")
        useratom = String.slice(message, start+1, String.length(message))
        {_status, coins} = ChatbotWeb.CoinGecko.search(%{query: useratom})
        content = handle_search(coins)
        %{uuid: UUID.uuid4(), content: content, username: socket.assigns.username}
      String.contains?(message, "search-by-id") ->
        {start, _end} = :binary.match(message, ":")
        useratom = String.slice(message, start+1, String.length(message))
        {status, coin} = ChatbotWeb.CoinGecko.coin(useratom)
        content = if status == :ok do handle_coin(coin) else "Could not find coin with the given id" end
        %{uuid: UUID.uuid4(), content: content, username: socket.assigns.username}
      String.contains?(message, "coin-price") ->
        {start, _end} = :binary.match(message, ":")
        useratom = String.slice(message, start+1, String.length(message))
        {status, coin} = ChatbotWeb.CoinGecko.coinMarketChart(useratom)
        content = if status == :ok do handle_market_price(coin) else "Could not find coin with the given id" end
        %{uuid: UUID.uuid4(), content: content, username: socket.assigns.username}
      true ->
        %{uuid: UUID.uuid4(), content: message, username: socket.assigns.username}
    end

    ChatbotWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message)
    {:noreply, assign(socket, message: "", username: message.username)}
  end

  @impl true
  def handle_event("form_update", %{"chat" => %{"message" => message}}, socket) do
    {:noreply, assign(socket, message: message)}
  end

  @impl true
  def handle_info(%{event: "new-message", payload: message}, socket) do
    {:noreply, assign(socket, messages: [message])}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    join_messages =
      joins
      |> Map.keys()
      |> Enum.map(fn username -> %{type: :system, uuid: UUID.uuid4(), content: "#{username} joined"} end)

    leave_messages =
      leaves
      |> Map.keys()
      |> Enum.map(fn username -> %{type: :system, uuid: UUID.uuid4(), content: "#{username} left"} end)

    user_list = ChatbotWeb.Presence.list(socket.assigns.topic)
    |> Map.keys()

    {:noreply, assign(socket, messages: join_messages ++ leave_messages, user_list: user_list)}
  end

  def display_message(%{type: :system, uuid: uuid, content: content}) do
    ~E"""
    <p id=<%= uuid %>><em><%= content %></em></p>
    """
  end

  def display_message(%{uuid: uuid, content: content, username: username}) do
    ~E"""
    <p id=<%= uuid %>><strong><%= username %></strong>: <%= content %></p>
    """
  end

  def display_message(%{type: :welcome, uuid: uuid, username: username}) do
    ~E"""
      <span id=<%= uuid %>>Welcome <em><%= username %></em>!</p>
      <ul id="chat-welcome-option">
        <li>Type <strong>change-name :newname</strong> to change your username!</li>
        <li>Type <strong>search-by-name :name</strong> to search for coins by name</li>
        <li>Type <strong>search-by-id :id</strong> to search coin by id</li>
        <li>Type <strong>coin-price :id</strong> to get the price of coin</li>
      </ul>
    """
  end

  def handle_search(coins) do
    ~E"""
      <br />
      <%= for coin <- coins do %>
        <img src="<%= coin.thumb %>" align="bottom"/>
        <span># <%= coin.id %> :: <b><%= coin.name %></b> ( <%= coin.symbol %> ) - <%= coin.market_cap_rank %></span><br />
      <% end %>
    """
  end

  def handle_coin(coin) do
    ~E"""
      <br />
      <b>Name:</b> <%= coin.name %><br />
      <b>ID:</b> <%= coin.id %><br />
      <b>Symbol:</b> <%= coin.symbol %><br />
      <b>Categories:</b> <%= for category <- coin.categories do %> <%= category %> - <% end %><br />
      <b>Rank:</b> <%= coin.coingecko_rank %><br />
      <b>Score:</b> <%= coin.coingecko_score %><br />
      <b>Community Score:</b> <%= coin.community_score %>
    """
  end

  def handle_market_price(prices) do
    ~E"""
      <br />
      <%= for price <- prices.prices do %>
        <%= for p <- price do %>
          <%= p %>
        <% end %> <br />
      <% end %>
    """
  end
end
