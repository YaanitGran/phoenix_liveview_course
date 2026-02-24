defmodule PPhoenixLiveviewCourseWeb.GameLive.GameComponent do
  use Phoenix.Component

  attr :count, :integer, required: true
  attr :type, :atom, default: :good
  attr :game_id, :integer, required: true

  attr :on_tomatoe, :any, default: "on_tomatoe"


  def tomatoe_button(assigns) do
    assigns =
      if is_tuple(assigns.on_tomatoe) do
        assigns
        |> assign(:event, assigns.on_tomatoe |> elem(0))
        |> assign(:target, assigns.on_tomatoe |> elem(1))
      else
        assigns |> assign(:event, assigns.on_tomatoe) |> assign(:target, nil)
      end

    ~H"""
    <button
      phx-click={@event}
      phx-target={@target}
      phx-value-type={Atom.to_string(@type)}
      phx-value-count={@count}
      class="tomatoe-button"
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
      assigns
      |> assign(:good_percentage, calculate_percentage(total, assigns.good))
      |> assign(:bad_percentage, calculate_percentage(total, assigns.bad))

    ~H"""
    <div class="tomato-scoreboard">
      <div>
        <span>{@good_percentage}%</span>
        <span>GOOD!</span>
      </div>
      <div class="divider" />
      <div>
        <span>{@bad_percentage}%</span>
        <span>BAD!</span>
      </div>
    </div>
    """
  end

  defp calculate_percentage(total, count) do
    if total > 0, do: Float.round(count / total * 100, 1), else: 0
  end

  @doc """
  Renders a view counter badge.
  """
  def view_counter(assigns) do
    ~H"""
    <div class="view-counter-badge">
      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-eye">
        <path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0z"/>
        <circle cx="12" cy="12" r="3"/>
      </svg>
      <span class="view-count-text" style="font-weight: bold;">
        {@count} views
      </span>
    </div>
    """
  end

end
