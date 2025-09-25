defmodule HelloApp.TestsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HelloApp.Tests` context.
  """

  @doc """
  Generate a test.
  """
  def test_fixture(attrs \\ %{}) do
    {:ok, test} =
      attrs
      |> Enum.into(%{
        results: %{}
      })
      |> HelloApp.Tests.create_test()

    test
  end
end
