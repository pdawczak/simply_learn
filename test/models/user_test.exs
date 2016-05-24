defmodule SL.UserTest do
  use SL.ModelCase

  alias SL.User

  @valid_attrs %{auth_client: "some content", auth_id: "some content", email: "some content", first_name: "some content", last_name: "some content", picture_url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
