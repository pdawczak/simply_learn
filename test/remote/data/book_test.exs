defmodule SL.Remote.Data.BookTest do
  use ExUnit.Case

  alias SL.Remote.Data.{Book, BookTest}

  defstruct [:isbn, :title]

  defmodule TestServiceForTitle do
    def get_data(_isbn, parent) do
      send parent, %{title: "Sample Book"}
    end
  end

  defmodule TestServiceForDescription do
    def get_data(_isbn, parent) do
      send parent, %{description: "Best description"}
    end
  end

  test "calls external services and merges the results" do
    services = [TestServiceForTitle,
                TestServiceForDescription]
    result = Book.get_data("test-123", %{}, [services: services])

    assert result == %{title: "Sample Book",
                       description: "Best description"}
  end

  test "merges result int provided argument" do
    services = [TestServiceForTitle]
    result = Book.get_data("test-123", %BookTest{isbn: "test-123"}, [services: services])

    assert result == %BookTest{isbn: "test-123",
                               title: "Sample Book"}
  end
end
