defmodule HelloApp.Repo do
  use Ecto.Repo,
    otp_app: :hello_app,
    adapter: Ecto.Adapters.SQLite3
end
