ExUnit.start

Mix.Task.run "ecto.create", ~w(-r SL.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r SL.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(SL.Repo)

