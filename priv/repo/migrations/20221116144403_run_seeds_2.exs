defmodule Jalka2022.Repo.Migrations.RunSeeds do
  use Ecto.Migration

  def change do
    Jalka2022.Seed.seed2()
  end
end
