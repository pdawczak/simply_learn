defmodule SL.Remote.Data.BookService do
  @doc """
    This is function to perform remote call, gather the data and process it
    to simple `Map` to be sent back to `parent`.
  """
  @callback get_data(isbn :: String.t, parent :: PID.t) :: %{}
end
