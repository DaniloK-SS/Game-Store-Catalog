defmodule GameStore.GamesTest do
  use GameStore.DataCase

  alias GameStore.Games

  describe "get_game/1" do
    test "returns {:ok, game} if the game is found" do
      game = game_fixture()

      assert {:ok, found_game} = Games.get_game(game.id)
      assert found_game.id == game.id
    end

    test "returns error when the game is not found" do
      assert {:error, :not_found} = Games.get_game(500)
    end
  end

  describe "create_game/1" do
    test "returns {:ok, game} if the game is created successfully" do
      attrs = valid_attr_fixture()

      assert {:ok, created_game} = Games.create_game(attrs)
      assert created_game.title == attrs.title
    end

    test "returns changeset error if the creation was not successfull" do
      attrs = invalid_attr_fixture()

      assert {:error, changeset} = Games.create_game(attrs)
      assert "can't be blank" in errors_on(changeset).title
    end
  end

  describe "update_game/2" do
    test "returns {:ok, game} if the game is updated successfully" do
      game = game_fixture()
      attrs = %{title: "test_title"}

      assert {:ok, updated_game} = Games.update_game(game, attrs)
      assert {:ok, fetched_game} = Games.get_game(game.id)
      assert updated_game == fetched_game
      assert updated_game.title == attrs.title
    end

    test "returns {:error, changeset} if the update was not successfull" do
      game = game_fixture()
      attrs = %{title: 0}

      assert {:error, changeset} = Games.update_game(game, attrs)
      assert "is invalid" in errors_on(changeset).title
      assert {:ok, fetched_game} = Games.get_game(game.id)
      assert fetched_game.title == game.title
    end
  end

  describe "list_games/1" do
    test "returns all games when no params are given" do
      %{a: game_a, b: game_b, c: game_c} = list_games_fixture()

      result = Games.list_games()
      result_ids = Enum.map(result, & &1.id)

      assert length(result) == 3
      assert game_a.id in result_ids
      assert game_b.id in result_ids
      assert game_c.id in result_ids
    end

    test "returns games with platform filter" do
      %{a: game_a, b: game_b, c: game_c} = list_games_fixture()

      params = %{"platform" => "PC"}

      result = Games.list_games(params)
      result_ids = Enum.map(result, & &1.id)

      assert length(result) == 2
      assert game_a.id in result_ids
      assert game_c.id in result_ids
      refute game_b.id in result_ids
    end

    test "returns games with genre filter" do
      %{a: game_a, b: game_b, c: game_c} = list_games_fixture()

      params = %{"genre" => "RPG"}

      result = Games.list_games(params)
      result_ids = Enum.map(result, & &1.id)

      assert length(result) == 2
      assert game_b.id in result_ids
      assert game_c.id in result_ids
      refute game_a.id in result_ids
    end

    test "returns games with in_stock == true" do
      %{a: game_a, b: game_b, c: game_c} = list_games_fixture()

      params = %{"in_stock" => "true"}

      result = Games.list_games(params)
      result_ids = Enum.map(result, & &1.id)

      assert length(result) == 2
      assert game_a.id in result_ids
      assert game_b.id in result_ids
      refute game_c.id in result_ids
    end

    test "returns games with in_stock == false" do
      %{a: game_a, b: game_b, c: game_c} = list_games_fixture()

      params = %{"in_stock" => "false"}

      result = Games.list_games(params)
      result_ids = Enum.map(result, & &1.id)

      assert length(result) == 1
      assert game_c.id in result_ids
      refute game_a.id in result_ids
      refute game_b.id in result_ids
    end

    test "returns games filtered by search" do
      %{a: game_a, b: game_b, c: game_c} = list_games_fixture()

      params = %{"search" => "A Game"}

      result = Games.list_games(params)
      result_ids = Enum.map(result, & &1.id)

      assert length(result) == 1
      assert game_a.id in result_ids
      refute game_b.id in result_ids
      refute game_c.id in result_ids
    end

    test "returns games in asc order" do
      %{a: game_a, b: game_b, c: game_c} = list_games_fixture()

      params = %{"sort" => "priceLow"}

      result = Games.list_games(params)
      result_ids = Enum.map(result, & &1.id)

      assert length(result) == 3
      assert result_ids == [game_a.id, game_b.id, game_c.id]
    end

    test "returns games sorted by newest first" do
      %{a: game_a, b: game_b, c: game_c} = list_games_fixture()

      params = %{"sort" => "newest"}

      result = Games.list_games(params)
      result_ids = Enum.map(result, & &1.id)

      assert length(result) == 3
      assert result_ids == [game_c.id, game_b.id, game_a.id]
    end

    test "returns games sorted by title" do
      %{a: game_a, b: game_b, c: game_c} = list_games_fixture()

      params = %{"sort" => "title"}

      result = Games.list_games(params)
      result_ids = Enum.map(result, & &1.id)

      assert length(result) == 3
      assert result_ids == [game_a.id, game_b.id, game_c.id]
    end

    test "Combines platform and genre filters" do
      %{a: game_a, b: game_b, c: game_c} = list_games_fixture()

      params = %{"platform" => "PC", "genre" => "RPG"}

      result = Games.list_games(params)
      result_ids = Enum.map(result, & &1.id)

      assert length(result) == 1
      refute game_a.id in result_ids
      refute game_b.id in result_ids
      assert game_c.id in result_ids
    end

    test "Combines platform and in_stock filters" do
      %{a: game_a, b: game_b, c: game_c} = list_games_fixture()

      params = %{"platform" => "PC", "in_stock" => "true"}

      result = Games.list_games(params)
      result_ids = Enum.map(result, & &1.id)

      assert length(result) == 1
      assert game_a.id in result_ids
      refute game_b.id in result_ids
      refute game_c.id in result_ids
    end

    test "Combines platform and sort filters" do
      %{a: game_a, c: game_c} = list_games_fixture()

      params = %{"platform" => "PC", "sort" => "priceHigh"}

      result = Games.list_games(params)
      result_ids = Enum.map(result, & &1.id)

      assert length(result) == 2
      assert result_ids == [game_c.id, game_a.id]
    end
  end

  describe "delete_game/1" do
    test "deletes the game when cover_image is nil" do
      game = game_fixture(%{cover_image: nil})

      assert {:ok, deleted_game} = Games.delete_game(game)
      assert deleted_game.id == game.id
      assert {:error, :not_found} = Games.get_game(game.id)
    end

    test "returns an error and keeps the game when image deletion fails" do
      game = game_fixture(%{cover_image: "delete-fails"})

      assert {:error, :delete_failed} = Games.delete_game(game)
      assert {:ok, fetched_game} = Games.get_game(game.id)
      assert fetched_game.id == game.id
    end

    test "deletes the game when image deletion succeeds" do
      game = game_fixture(%{cover_image: "some-valid-url"})

      assert {:ok, deleted_game} = Games.delete_game(game)
      assert deleted_game.id == game.id
      assert {:error, :not_found} = Games.get_game(game.id)
    end

    test "deletes the game when cover_image is invalid" do
      game = game_fixture(%{cover_image: "bad-url"})

      assert {:ok, deleted_game} = Games.delete_game(game)
      assert deleted_game.id == game.id
      assert {:error, :not_found} = Games.get_game(game.id)
    end
  end

  defp invalid_attr_fixture() do
    %{
      title: nil,
      genre: "FPS",
      platform: "PC",
      price: Decimal.new("59.99"),
      release_year: 2022,
      in_stock: true,
      cover_image: nil,
      publisher: "Valve"
    }
  end

  defp valid_attr_fixture() do
    %{
      title: "Counter Strike",
      genre: "FPS",
      platform: "PC",
      price: Decimal.new("59.99"),
      release_year: 2022,
      in_stock: true,
      cover_image: nil,
      publisher: "Valve"
    }
  end

  defp game_fixture(attrs \\ %{}) do
    valid_attrs = %{
      title: "Elden Ring",
      genre: "RPG",
      platform: "PC",
      price: Decimal.new("59.99"),
      release_year: 2022,
      in_stock: true,
      cover_image: nil,
      publisher: "EA"
    }

    {:ok, game} =
      valid_attrs
      |> Map.merge(attrs)
      |> Games.create_game()

    game
  end

  defp list_games_fixture do
    game_a =
      game_fixture(%{
        title: "A Game",
        genre: "Action",
        platform: "PC",
        in_stock: true,
        price: Decimal.new("10.00"),
        release_year: 2020
      })

    game_b =
      game_fixture(%{
        title: "B Game",
        genre: "RPG",
        platform: "PlayStation",
        in_stock: true,
        price: Decimal.new("20.00"),
        release_year: 2022
      })

    game_c =
      game_fixture(%{
        title: "C Game",
        genre: "RPG",
        platform: "PC",
        in_stock: false,
        price: Decimal.new("30.00"),
        release_year: 2024
      })

    %{
      a: game_a,
      b: game_b,
      c: game_c
    }
  end
end
