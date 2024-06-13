defmodule Jalka2024.Seed do
  require Logger
  def seed do
    prefix = case Application.get_env(:jalka2024, :environment) do
      :prod -> "/app/lib/jalka2024-0.1.0"
      _ -> Mix.Project.app_path()
    end
    if Code.ensure_compiled(Jalka2024.Accounts.AllowedUser) &&
         Jalka2024.Accounts.AllowedUser |> Jalka2024.Repo.aggregate(:count, :id) == 0 do
      Enum.each(
        Jason.decode!(File.read!('#{prefix}/priv/repo/data/allowed_users.json')),
        fn attrs ->
          %Jalka2024.Accounts.AllowedUser{}
          |> Jalka2024.Accounts.AllowedUser.changeset(attrs)
          |> Jalka2024.Repo.insert!()
        end
      )
    end

    if Code.ensure_compiled(Jalka2024.Football.Team) &&
         Jalka2024.Football.Team |> Jalka2024.Repo.aggregate(:count, :id) == 0 do
      Enum.each(
        Jason.decode!(File.read!('#{prefix}/priv/repo/data/teams.json')),
        fn attrs ->
          %Jalka2024.Football.Team{}
          |> Jalka2024.Football.Team.changeset(%{
            id: Map.get(attrs, "id"),
            name: Map.get(attrs, "name"),
            code: Map.get(attrs, "tla"),
            flag: Map.get(attrs, "crest"),
            group: Map.get(attrs, "group")
          })
          |> Jalka2024.Repo.insert!()
        end
      )
    end

    if Code.ensure_compiled(Jalka2024.Football.Match) &&
         Jalka2024.Football.Match |> Jalka2024.Repo.aggregate(:count, :id) == 0 do
      Enum.each(
        Jason.decode!(File.read!('#{prefix}/priv/repo/data/matches.json')),
        fn attrs ->
          if (Map.get(attrs, "stage") == "GROUP_STAGE") do
            %Jalka2024.Football.Match{}
            |> Jalka2024.Football.Match.changeset(%{
              group: Map.get(attrs, "group"),
              home_team_id: Kernel.get_in(attrs, ["homeTeam", "id"]),
              away_team_id: Kernel.get_in(attrs, ["awayTeam", "id"]),
              date: Map.get(attrs, "utcDate")
            })
            |> Jalka2024.Repo.insert!()
          end
        end
      )
    end
  end

  def seed2 do
    prefix = case Application.get_env(:jalka2024, :environment) do
      :prod -> "/app/lib/jalka2024-0.1.0"
      _ -> Mix.Project.app_path()
    end
    if Code.ensure_compiled(Jalka2024.Accounts.AllowedUser) &&
         Jalka2024.Accounts.AllowedUser |> Jalka2024.Repo.aggregate(:count, :id) <= 55 do
      Logger.info("Adding secondary seed data...")
      Enum.each(
        Jason.decode!(File.read!('#{prefix}/priv/repo/data/allowed_users2.json')),
        fn attrs ->
          %Jalka2024.Accounts.AllowedUser{}
          |> Jalka2024.Accounts.AllowedUser.changeset(attrs)
          |> Jalka2024.Repo.insert!()
        end
      )
    end
  end
end
