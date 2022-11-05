import Config

if Config.config_env() == :dev do
  DotenvParser.load_file(".env") # Works because the dependency is already compiled
end

case Config.config_env() do
  :prod ->
    config :jalka2022, Jalka2022Web.Endpoint,
           secret_key_base: System.get_env("SECRET_KEY_BASE"),
           live_view: [signing_salt: System.get_env("SIGNING_SALT")],
           server: true

  :dev ->
    config :jalka2022, Jalka2022Web.Endpoint,
           server: true
end