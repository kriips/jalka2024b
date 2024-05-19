defmodule Jalka2024Web.UserSessionController do
  use Jalka2024Web, :controller

  alias Jalka2024.Accounts
  alias Jalka2024Web.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"name" => name, "password" => password} = user_params

    if user = Accounts.get_user_by_name_and_password(name, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      render(conn, "new.html", error_message: "Vale nimi või parool")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Oled välja logitud")
    |> UserAuth.log_out_user()
  end
end
