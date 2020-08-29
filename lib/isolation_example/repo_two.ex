defmodule IsolationExample.RepoTwo do
  use Ecto.Repo,
    otp_app: :isolation_example,
    adapter: Ecto.Adapters.Postgres
end
