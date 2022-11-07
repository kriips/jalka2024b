import Config

if Config.config_env() == :dev do
  # Works because the dependency is already compiled
  DotenvParser.load_file(".env")
end

case Config.config_env() do
  :prod ->
    config :jalka2022, Jalka2022Web.Endpoint,
      secret_key_base: System.get_env("SECRET_KEY_BASE"),
      live_view: [signing_salt: System.get_env("SIGNING_SALT")],
      server: true

  :dev ->
    config :jalka2022, Jalka2022Web.Endpoint, server: true
end


maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []
database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :jalka2022, Jalka2022.Repo,
       # ssl: true,
       url: database_url,
       pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
       socket_options: maybe_ipv6