import Config

if Config.config_env() == :dev do
  # Works because the dependency is already compiled
  DotenvParser.load_file(".env")
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

case Config.config_env() do
  :prod ->
    app_name =
      System.get_env("FLY_APP_NAME") ||
        raise "FLY_APP_NAME not available"

    secret_key =
      System.get_env("SECRET_KEY_BASE") ||
        raise """
        environment variable SECRET_KEY_BASE is missing.
        """

    signing_salt =
      System.get_env("SIGNING_SALT") ||
        raise """
        environment variable SIGNING_SALT is missing.
        """

    port =
      System.get_env("PORT") ||
        raise """
        environment variable PORT is missing.
        """

    config :jalka2022, Jalka2022Web.Endpoint,
      url: [host: "#{app_name}.fly.dev", port: 80],
      http: [
        ip: {0, 0, 0, 0, 0, 0, 0, 0},
        port: String.to_integer(port)
      ],
      secret_key_base: secret_key,
      live_view: [signing_salt: signing_salt],
      server: true,
      check_origin: [
        "//jalka2022.fly.dev",
        "//jalka.eys.ee"
      ]

    config :libcluster,
      debug: true,
      topologies: [
        fly6pn: [
          strategy: Cluster.Strategy.DNSPoll,
          config: [
            polling_interval: 5_000,
            query: "#{app_name}.internal",
            node_basename: app_name
          ]
        ]
      ]

  :dev ->
    config :jalka2022, Jalka2022Web.Endpoint, server: true
end
