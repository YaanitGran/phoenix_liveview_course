defmodule PPhoenixLiveviewCourseWeb.GameLive.GameComponent do
  use Phoenix.Component

  attr :count, :integer, required: true
  attr :type, :atom, default: :good
  attr :game_id, :integer, required: true

  attr :on_tomatoe, :string, default: "on_tomatoe"

  def tomatoe_button(assigns) do
    ~H"""
    <button
      phx-click={@on_tomatoe}
      phx-value-type={Atom.to_string(@type)}
      phx-value-count={@count}
      class="p-2 border"
    >
      <span>{@count}</span>
      <span>{if @type == :good, do: "🍏", else: "🍎"}</span>
    </button>
    """
  end

  attr :good, :integer, default: 0
  attr :bad, :integer, default: 0

  def tomatoes_score(assigns) do
    total = assigns.good + assigns.bad

    assigns =
      Map.put(assigns, :good_percentage, Float.round(assigns.good / total * 100, 1))
      |> Map.put(:bad_percentage, Float.round(assigns.bad / total * 100, 1))

    ~H"""
    <div class="flex justify-center items-center gap-2">
      <span class="text-green-700 text-lg">{assigns.good_percentage}%</span>
      <span class="text-red-600 text-lg">{assigns.bad_percentage}%</span>
    </div>
    """
  end
end
