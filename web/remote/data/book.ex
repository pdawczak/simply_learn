defmodule SL.Remote.Data.Book do
  @services [SL.Remote.Data.Book.Amazon,
             SL.Remote.Data.Book.Upcitemdb]

  def get_data(isbn, to_merge \\ %{}, opts \\ []) do
    parent = self()
    services = opts[:services] || @services

    services
    |> Enum.map(&spawn_link(&1, :get_data, [isbn, parent]))
    |> Enum.map(fn _ -> await_result end)
    |> Enum.reduce(to_merge, &Map.merge(&2, &1))
  end

  defp await_result do
    receive do
      data -> data
    end
  end
end
