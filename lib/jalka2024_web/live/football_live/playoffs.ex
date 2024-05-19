defmodule Jalka2024Web.FootballLive.Playoffs do
  use Phoenix.LiveView

  alias Jalka2024Web.Resolvers.FootballResolver

  @impl true
  def mount(_params, _session, socket) do
    predictions = FootballResolver.get_playoff_predictions()
    {:ok, assign(socket, predictions: predictions)}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2024Web.PlayoffsView, "playoffs.html", assigns)
end
