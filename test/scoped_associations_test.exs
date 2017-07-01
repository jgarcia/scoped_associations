defmodule ScopedAssociationsTest do
  use ExUnit.Case
  doctest ScopedAssociations
  alias ScopedAssociations.Test.{Comment, Post}
  alias ScopedAssociations.Repo
  import ScopedAssociations.Test.Factory
  import Ecto.Query

  setup do
    Repo.delete_all(Post)
    Repo.delete_all(Comment)

    {:ok, post} = create(:post, %{title: "Post 1", body: "Body 1"})
    create(:post, %{title: "Post 2", body: "Body 2"})
    create(:comment, %{email: "t1@user.com", body: "Body 1", post_id: post.id})
    create(:comment, %{email: "t2@user.com", body: "Body 2", post_id: post.id})
    create(:comment, %{email: "t3@user.com", body: "Body 3", post_id: post.id})
    create(:comment, %{email: "t4@user.com", body: "Body 4", post_id: post.id})
    create(:comment, %{email: "t5@user.com", body: "Body 5", post_id: post.id})
    :ok
  end

  test "can load a scoped association" do
    post  = Repo.all(Post)
            |> Post.include([:first_comment])
            |> Enum.at(0)

    first_comment = Comment
                    |> first
                    |> Repo.one

    assert post.first_comment == first_comment
  end

  test "can load multiple scoped associations" do
    post = Repo.all(Post)
           |> Post.include([:first_comment, :recent_comments])
           |> Enum.at(0)

    assert post.first_comment != nil
    assert post.recent_comments != nil
  end
end
