defmodule PPhoenixLiveviewCourseWeb.PokemonLiveTest do
  use PPhoenixLiveviewCourseWeb.ConnCase
  import Phoenix.LiveViewTest

  @battle_topic "pokemon_battle"

  describe "Pokemon Battle LiveView Integration" do

    test "renders pokemon list and allows a player to choose one", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/pokemon")

      assert render(view) =~ "Choose your Pokemon"

      view
      |> element("div[phx-click='choose_pokemon'][phx-value-id='2']")
      |> render_click()

      # Checking for the pokemon name based on your init_pokemons
      assert render(view) =~ "Squirtle"
    end

    test "triggers battle logic via PubSub", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/pokemon")

      # Choose first pokemon
      view |> element("div[phx-click='choose_pokemon'][phx-value-id='1']") |> render_click()

      # FIX 1: Adding image_url to prevent KeyError in components
      Phoenix.PubSub.broadcast(
        PPhoenixLiveviewCourse.PubSub,
        @battle_topic,
        {:pokemon_chosen, "other_player", %{id: 2, name: "Squirtle", type: :water, image_url: "/images/squirtle.png"}}
      )

      html = render(view)
      assert html =~ "Charmander"
      assert html =~ "Squirtle"
    end

    test "resets the game for all users", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/pokemon")

      # FIX 2: We must complete a battle so the Reset button appears (:if logic)
      view |> element("div[phx-click='choose_pokemon'][phx-value-id='1']") |> render_click()

      Phoenix.PubSub.broadcast(
        PPhoenixLiveviewCourse.PubSub,
        @battle_topic,
        {:pokemon_chosen, "other_player", %{id: 2, name: "Squirtle", type: :water, image_url: "/images/squirtle.png"}}
      )

      # Now that battle_result is NOT nil, the button should be there
      view |> element("button[phx-click='request-reset']") |> render_click()

      # State should be back to initial (p1 and p2 are nil)
      assert render(view) =~ "Choose your Pokemon"
      refute render(view) =~ "You"
    end
  end
end
