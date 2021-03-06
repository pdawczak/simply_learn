defmodule SL.BorrowingTest do
  use SL.ModelCase

  alias SL.Borrowing

  @valid_attrs %{ended_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, started_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Borrowing.changeset(%Borrowing{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Borrowing.changeset(%Borrowing{}, @invalid_attrs)
    refute changeset.valid?
  end
end
