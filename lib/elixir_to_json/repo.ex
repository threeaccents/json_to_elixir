defmodule ETJ.Repo do
  use Ecto.Repo,
    otp_app: :elixir_to_json,
    adapter: Ecto.Adapters.Postgres
end
