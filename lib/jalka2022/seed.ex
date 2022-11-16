defmodule Jalka2022.Seed do
  def seed do
    if Code.ensure_compiled(Jalka2022.Accounts.AllowedUser) &&
         Jalka2022.Accounts.AllowedUser |> Jalka2022.Repo.aggregate(:count, :id) == 0 do
      Enum.each(
        Jason.decode!(File.read!('/app/lib/jalka2022-0.1.0/priv/repo/data/allowed_users.json')),
        fn attrs ->
          %Jalka2022.Accounts.AllowedUser{}
          |> Jalka2022.Accounts.AllowedUser.changeset(attrs)
          |> Jalka2022.Repo.insert!()
        end
      )
    end

    if Code.ensure_compiled(Jalka2022.Football.Team) &&
         Jalka2022.Football.Team |> Jalka2022.Repo.aggregate(:count, :id) == 0 do
      Enum.each(
        Jason.decode!(File.read!('/app/lib/jalka2022-0.1.0/priv/repo/data/teams.json')),
        fn attrs ->
          %Jalka2022.Football.Team{}
          |> Jalka2022.Football.Team.changeset(%{
            id: Map.get(attrs, "id"),
            name: Map.get(attrs, "name"),
            code: Map.get(attrs, "tla"),
            flag: Map.get(attrs, "crest"),
            group: Map.get(attrs, "group")
          })
          |> Jalka2022.Repo.insert!()
        end
      )
    end

    if Code.ensure_compiled(Jalka2022.Football.Match) &&
         Jalka2022.Football.Match |> Jalka2022.Repo.aggregate(:count, :id) == 0 do
      Enum.each(
        Jason.decode!(File.read!('/app/lib/jalka2022-0.1.0/priv/repo/data/matches.json')),
        fn attrs ->
          %Jalka2022.Football.Match{}
          |> Jalka2022.Football.Match.changeset(%{
            group: Map.get(attrs, "group"),
            home_team_id: Kernel.get_in(attrs, ["homeTeam", "id"]),
            away_team_id: Kernel.get_in(attrs, ["awayTeam", "id"]),
            date: Map.get(attrs, "utcDate")
          })
          |> Jalka2022.Repo.insert!()
        end
      )
    end
  end

  def seed2 do
    if Code.ensure_compiled(Jalka2022.Accounts.AllowedUser) &&
         Jalka2022.Accounts.AllowedUser |> Jalka2022.Repo.aggregate(:count, :id) <= 976 do
      Enum.each(
        Jason.decode!(File.read!('/app/lib/jalka2022-0.1.0/priv/repo/data/allowed_users2.json')),
        fn attrs ->
          %Jalka2022.Accounts.AllowedUser{}
          |> Jalka2022.Accounts.AllowedUser.changeset(attrs)
          |> Jalka2022.Repo.insert!()
        end
      )
    end
  end
end
