defmodule RankTracker.NotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RankTracker.Notes` context.
  """

  @doc """
  Generate a note.
  """
  def note_fixture(attrs \\ %{}) do
    {:ok, note} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> RankTracker.Notes.create_note()

    note
  end
end
