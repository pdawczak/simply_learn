{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:bypass)

ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(SL.Repo, :manual)

