defmodule Jalka2024Web.LeaderboardLive.Leaderboard do
  use Phoenix.LiveView

  alias Jalka2024.Leaderboard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, leaderboard: Leaderboard.get_leaderboard())}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2024Web.LeaderboardView, "leaderboard.html", assigns)
end
