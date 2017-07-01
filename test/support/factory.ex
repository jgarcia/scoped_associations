defmodule ScopedAssociations.Test.Factory do
  alias ScopedAssociations.Repo
  alias ScopedAssociations.Test.{Post, Comment}

  def create(:post, attrs) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert
  end

  def create(:comment, attrs) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert
  end
end
