defmodule PPhoenixLiveviewCourse.Repo.Migrations.AddViewsToGames do
  use Ecto.Migration

  def change do
    # Add a views column to the games table with a default value of 0
    alter table(:games) do
      add :views, :integer, default: 0
    end
  end
end
