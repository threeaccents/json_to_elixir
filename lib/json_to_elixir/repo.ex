defmodule JTE.Repo do
  use Ecto.Repo,
    otp_app: :json_to_elixir,
    adapter: Ecto.Adapters.Postgres
end
