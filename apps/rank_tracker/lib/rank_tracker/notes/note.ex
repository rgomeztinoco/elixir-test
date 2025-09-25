defmodule RankTracker.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
