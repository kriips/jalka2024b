defmodule Jalka2022.Seed do
  import Ecto.Changeset
  def seed do
    # Script for populating the database. You can run it as:
    #
    #     mix run priv/repo/seeds.exs
    #
    # Inside the script, you can read and write to any of your
    # repositories directly:
    #`
    #     Jalka2022.Repo.insert!(%Jalka2022.SomeSchema{})
    #
    # We recommend using the bang functions (`insert!`, `update!`
    # and so on) as they will fail if something goes wrong.

    if Code.ensure_compiled?(Jalka2022.Accounts.AllowedUser) &&
         Jalka2022.Accounts.AllowedUser |> Jalka2022.Repo.aggregate(:count, :id) == 0 do
      Enum.each(Jason.decode!(File.read!('priv/repo/data/allowed_users.json')), fn attrs ->
        %Jalka2022.Accounts.AllowedUser{}
        |> Jalka2022.Accounts.AllowedUser.changeset(attrs)
        |> Jalka2022.Repo.insert!()
      end)
    end

    if Code.ensure_compiled?(Jalka2022.Football.Team) &&
         Jalka2022.Football.Team |> Jalka2022.Repo.aggregate(:count, :id) == 0 do
      Enum.each(Jason.decode!(File.read!('priv/repo/data/teams.json')), fn attrs ->
        %Jalka2022.Football.Team{}
        |> Jalka2022.Football.Team.changeset(%{
          id: Map.get(attrs, "id"),
          name: Map.get(attrs, "name"),
          code: Map.get(attrs, "tla"),
          flag: Map.get(attrs, "crest"),
          group: Map.get(attrs, "group")
        })
        |> Jalka2022.Repo.insert!()
      end)
    end

    if Code.ensure_compiled?(Jalka2022.Football.Match) &&
         Jalka2022.Football.Match |> Jalka2022.Repo.aggregate(:count, :id) == 0 do
      Enum.each(Jason.decode!(File.read!('priv/repo/data/matches.json')), fn attrs ->
        %Jalka2022.Football.Match{}
        |> Jalka2022.Football.Match.changeset(%{
          group: Map.get(attrs, "group"),
          home_team_id: Kernel.get_in(attrs, ["homeTeam", "id"]),
          away_team_id: Kernel.get_in(attrs, ["awayTeam", "id"]),
          date: Map.get(attrs, "utcDate")
        })
        |> Jalka2022.Repo.insert!()
      end)
    end
  end
end