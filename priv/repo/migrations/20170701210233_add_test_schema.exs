defmodule ScopedAssociations.Repo.Migrations.AddTestSchema do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :string

      timestamps()
    end

    create table(:comments) do
      add :email, :string
      add :body, :string
      add :post_id, :integer

      timestamps()
    end
  end
end
