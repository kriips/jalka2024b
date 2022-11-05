defmodule Jalka2022Web.FootballLive.Playoffs do
  use Phoenix.LiveView

  alias Jalka2022Web.Resolvers.FootballResolver
  alias Jalka2022Web.LiveHelpers

  @impl true
  def mount(_params, session, socket) do
    predictions = FootballResolver.get_playoff_predictions()
    {:ok, assign(socket, predictions: predictions)}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2022Web.PlayoffsView, "playoffs.html", assigns)
end
