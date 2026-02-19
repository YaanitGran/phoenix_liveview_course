defmodule PPhoenixLiveviewCourseWeb.BlackjackLive do
  use PPhoenixLiveviewCourseWeb, :live_view

  @cards [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(game_title: "Blackjack ♥️♣️♠️♦️") |> init_deck() |> first_deal(),
     layout: {PPhoenixLiveviewCourseWeb.Layouts, :game}}
  end

  @impl true
  def handle_event("draw", %{"count" => count}, socket) do
    {:noreply,
     socket
     |> draw_card(String.to_integer(count))
     |> cpu_draw_card(String.to_integer(count))
     |> handle_winner_on_draw()}
  end

  @impl true
  def handle_event("stand", _params, socket) do
    {:noreply, socket |> cpu_draw_card(1) |> handle_winner_on_stand()}
  end

    @impl true
  def handle_event("reset", _params, socket) do
    {:noreply, socket |> init_deck() |> first_deal()}
  end

  # Privates
  defp init_deck(socket) do
    socket |> assign(cards: @cards, player: [], cpu: [], winner: nil)
  end

  defp first_deal(socket) do
    [card1, card2, card3, card4] = Enum.take_random(@cards, 4)
    socket |> assign(player: [card1, card2], cpu: [card3, card4])
  end

  defp points(cards) do
    Enum.reduce(cards, 0, fn card, acc -> acc + card end)
  end

  defp draw_card(socket, count) do
    if points(socket.assigns.player) < socket.assigns.winning_score do
      [card1] = Enum.take_random(@cards, count)
      new_player_cards = [card1 | socket.assigns.player]

      socket |> assign(player: new_player_cards)
    else
      socket |> put_flash(:error, "Cannot take another card")
    end
  end

  defp cpu_draw_card(socket, count) do
    if points(socket.assigns.cpu) < 17 do
      [card1] = Enum.take_random(@cards, count)
      new_cpu_cards = [card1 | socket.assigns.cpu]

      socket |> assign(cpu: new_cpu_cards)
    else
      socket
    end
  end

  defp handle_winner_on_draw(socket) do
    player_points = points(socket.assigns.player)
    cpu_points = points(socket.assigns.cpu)
    limit = socket.assigns.winning_score

    winner =
      cond do
        player_points > limit -> :cpu
        cpu_points > limit -> :player
        true -> nil
      end

    socket |> assign(winner: winner)
  end

  defp handle_winner_on_stand(socket) do
    player_points = points(socket.assigns.player)
    cpu_points = points(socket.assigns.cpu)
    limit = socket.assigns.winning_score

    winner =
      cond do
        player_points > limit -> :cpu
        cpu_points > limit -> :player
        player_points > cpu_points -> :player
        player_points < cpu_points -> :cpu
        true -> :tie
      end

    socket |> assign(winner: winner)
  end
  
  @impl true
  def handle_params(params, _url, socket) do
    # Get "score" from URL params, default to 21 if not present or invalid
    winning_score =
      params
      |> Map.get("score", "21")
      |> String.to_integer()

    {:noreply, assign(socket, winning_score: winning_score)}
  end


end
