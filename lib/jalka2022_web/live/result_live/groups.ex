defmodule Jalka2022Web.ResultLive.Groups do
  use Phoenix.LiveView

  alias Jalka2022Web.Resolvers.FootballResolver
  alias Jalka2022Web.LiveHelpers

  @impl true
  def mount(_params, session, socket) do
    socket = LiveHelpers.assign_defaults(session, socket)
    {:ok, socket}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2022Web.ResultView, "groups.html", assigns)

  @impl true
  def handle_event("save", values, socket) do
    FootballResolver.update_match(values["result"])
    {:noreply, socket}
  end
end
