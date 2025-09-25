defmodule HelloApp.Repo.Migrations.CreateTests do
  use Ecto.Migration

  def change do
    create table(:tests) do
      add :results, :map
      add :keyword_id, references(:keywords, on_delete: :nothing)
      add :project_id, references(:projects, on_delete: :nothing)

      timestamps()
    end

    create index(:tests, [:keyword_id])
    create index(:tests, [:project_id])
  end
end
