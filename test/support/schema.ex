defmodule ScopedAssociations.Test.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias ScopedAssociations.Test.{Post, Comment}
  use ScopedAssociations, repo: ScopedAssociations.Repo

  schema "posts" do
    field :title, :string
    field :body, :string
    has_many :comments, Comment

    timestamps()
  end

  has_one_scoped :first_comment, schema: Comment, foreign_key: "post_id", scope: :first_comment
  has_many_scoped :recent_comments, schema: Comment, foreign_key: "post_id", scope: :recent_comments

  def first_comment do
    from c in Comment,
      join: f in fragment("SELECT MIN(id) AS id, post_id FROM comments GROUP BY post_id"),
      on: c.id == f.id
  end

  def recent_comments do
    from c in Comment,
      order_by: [asc: c.inserted_at]
  end

  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end

defmodule ScopedAssociations.Test.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias ScopedAssociations.Test.{Post, Comment}

  schema "comments" do
    field :email, :string
    field :body, :string
    field :post_id, :integer

    timestamps()
  end

  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:email, :body, :post_id])
    |> validate_required([:email, :body, :post_id])
  end
end
