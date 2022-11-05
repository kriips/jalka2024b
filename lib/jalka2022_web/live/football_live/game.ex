defmodule Jalka2022Web.FootballLive.Game do
  use Phoenix.LiveView

  alias Jalka2022Web.Resolvers.FootballResolver
  alias Jalka2022Web.LiveHelpers

  @impl true
  def mount(params, session, socket) do
    {:ok,
     socket
     |> assign(
       predictions: FootballResolver.get_predictions_by_match_result(params["id"]),
       match: FootballResolver.list_match(params["id"])
     )}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2022Web.GamesView, "game.html", assigns)
end
