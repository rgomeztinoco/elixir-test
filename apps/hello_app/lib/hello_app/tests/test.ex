defmodule HelloApp.Tests.Test do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tests" do
    field :results, :map
    field :keyword_id, :id
    field :project_id, :id

    timestamps()
  end

  @doc false
  def changeset(test, attrs) do
    test
    |> cast(attrs, [:results])
    |> validate_required([])
  end
end
