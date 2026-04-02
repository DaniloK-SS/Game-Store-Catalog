defmodule GameStoreWeb.GameControllerTest do
  use GameStoreWeb.ConnCase, async: true

  alias GameStore.Accounts
  alias GameStore.Games

  describe "index/2" do
    test "returns games as json", %{conn: conn} do
      game = game_fixture(%{title: "Elden Ring"})

      conn = get(conn, ~p"/api/games")

      assert %{"data" => games} = json_response(conn, 200)
      assert Enum.any?(games, fn returned_game -> returned_game["id"] == game.id end)
      assert Enum.any?(games, fn returned_game -> returned_game["title"] == "Elden Ring" end)
    end

    test "filters games by platform", %{conn: conn} do
      pc_game = game_fixture(%{title: "Half-Life", platform: "PC"})
      _xbox_game = game_fixture(%{title: "Halo", platform: "Xbox"})

      conn = get(conn, ~p"/api/games?platform=PC")

      assert %{"data" => games} = json_response(conn, 200)
      assert length(games) == 1
      assert [%{"id" => returned_id, "platform" => "PC"}] = games
      assert returned_id == pc_game.id
    end

    test "returns bad request for invalid sort value", %{conn: conn} do
      conn = get(conn, ~p"/api/games?sort=banana")

      assert %{
               "error" => "Invalid sort value",
               "received" => "banana",
               "allowed" => ["priceLow", "priceHigh", "newest", "title"]
             } = json_response(conn, 400)
    end
  end

  describe "show/2" do
    test "returns a single game by id", %{conn: conn} do
      game = game_fixture(%{title: "Portal"})

      conn = get(conn, ~p"/api/games/#{game.id}")

      assert %{"data" => returned_game} = json_response(conn, 200)
      assert returned_game["id"] == game.id
      assert returned_game["title"] == "Portal"
    end

    test "returns not found when the game does not exist", %{conn: conn} do
      conn = get(conn, ~p"/api/games/999999")

      assert %{"error" => "Game not found"} = json_response(conn, 404)
    end
  end

  describe "create/2" do
    test "returns unauthorized without an api token", %{conn: conn} do
      conn =
        post(conn, ~p"/api/games", %{
          "game" => %{
            "title" => "Hades",
            "genre" => "RPG",
            "platform" => "PC",
            "price" => "29.99",
            "release_year" => 2020,
            "publisher" => "Supergiant Games"
          }
        })

      assert %{"error" => "Unauthorized"} = json_response(conn, 401)
    end

    test "creates a game with a valid admin token", %{conn: conn} do
      conn = authenticated_admin_conn(conn)

      conn =
        post(conn, ~p"/api/games", %{
          "game" => %{
            "title" => "Hades",
            "genre" => "RPG",
            "platform" => "PC",
            "price" => "29.99",
            "release_year" => 2020,
            "publisher" => "Supergiant Games",
            "cover_image" => "https://example.com/hades.png",
            "description" => "Escape the underworld.",
            "in_stock" => true,
            "featured" => false
          }
        })

      assert %{"data" => created_game} = json_response(conn, 201)
      assert created_game["title"] == "Hades"
      assert created_game["platform"] == "PC"
      assert created_game["publisher"] == "Supergiant Games"

      assert {:ok, persisted_game} = Games.get_game(created_game["id"])
      assert persisted_game.title == "Hades"
      assert persisted_game.platform == "PC"
      assert persisted_game.publisher == "Supergiant Games"
    end

    test "returns bad request for invalid game data", %{conn: conn} do
      conn = authenticated_admin_conn(conn)

      conn =
        post(conn, ~p"/api/games", %{
          "game" => %{
            "title" => nil,
            "genre" => "RPG",
            "platform" => "PC",
            "price" => "29.99",
            "release_year" => 2020,
            "publisher" => "Supergiant Games"
          }
        })

      assert %{"error" => "Invalid game data"} = json_response(conn, 400)
    end
  end

  describe "update/2" do
    test "returns unauthorized without an api token", %{conn: conn} do
      game = game_fixture(%{title: "Before Update"})

      conn =
        put(conn, ~p"/api/games/#{game.id}", %{
          "game" => %{
            "title" => "After Update"
          }
        })

      assert %{"error" => "Unauthorized"} = json_response(conn, 401)
    end

    test "updates a game with a valid admin token", %{conn: conn} do
      game = game_fixture(%{title: "Before Update", publisher: "Old Publisher"})
      conn = authenticated_admin_conn(conn)

      conn =
        put(conn, ~p"/api/games/#{game.id}", %{
          "game" => %{
            "title" => "After Update",
            "publisher" => "New Publisher"
          }
        })

      assert %{"data" => updated_game} = json_response(conn, 200)
      assert updated_game["id"] == game.id
      assert updated_game["title"] == "After Update"
      assert updated_game["publisher"] == "New Publisher"

      assert {:ok, persisted_game} = Games.get_game(game.id)
      assert persisted_game.title == "After Update"
      assert persisted_game.publisher == "New Publisher"
    end

    test "returns bad request for invalid update data", %{conn: conn} do
      game = game_fixture(%{title: "Before Update"})
      conn = authenticated_admin_conn(conn)

      conn =
        put(conn, ~p"/api/games/#{game.id}", %{
          "game" => %{
            "title" => nil
          }
        })

      assert %{"error" => "Invalid game data"} = json_response(conn, 400)
    end

    test "returns not found when updating a missing game", %{conn: conn} do
      conn = authenticated_admin_conn(conn)

      conn =
        put(conn, ~p"/api/games/999999", %{
          "game" => %{
            "title" => "After Update"
          }
        })

      assert %{"error" => "Game not found"} = json_response(conn, 404)
    end
  end

  describe "delete/2" do
    test "returns unauthorized without an api token", %{conn: conn} do
      game = game_fixture(%{title: "Delete Me"})

      conn = delete(conn, ~p"/api/games/#{game.id}")

      assert %{"error" => "Unauthorized"} = json_response(conn, 401)
    end

    test "deletes a game with a valid admin token", %{conn: conn} do
      game = game_fixture(%{title: "Delete Me", cover_image: nil})
      conn = authenticated_admin_conn(conn)

      conn = delete(conn, ~p"/api/games/#{game.id}")

      assert %{"data" => deleted_game} = json_response(conn, 200)
      assert deleted_game["id"] == game.id
      assert deleted_game["title"] == "Delete Me"
      assert {:error, :not_found} = Games.get_game(game.id)
    end

    test "returns not found when deleting a missing game", %{conn: conn} do
      conn = authenticated_admin_conn(conn)

      conn = delete(conn, ~p"/api/games/999999")

      assert %{"error" => "Game not found"} = json_response(conn, 404)
    end

    test "returns internal server error when image deletion fails", %{conn: conn} do
      game = game_fixture(%{title: "Delete Me", cover_image: "delete-fails"})
      conn = authenticated_admin_conn(conn)

      conn = delete(conn, ~p"/api/games/#{game.id}")

      assert %{"error" => message} = json_response(conn, 500)
      assert String.starts_with?(message, "Failed to delete game:")
    end
  end

  defp game_fixture(attrs) do
    valid_attrs = %{
      title: "Counter-Strike",
      genre: "Shooter",
      platform: "PC",
      price: Decimal.new("19.99"),
      release_year: 2023,
      publisher: "Valve",
      cover_image: "https://example.com/game-cover.png",
      description: "A test game description",
      in_stock: true,
      featured: false
    }

    {:ok, game} =
      valid_attrs
      |> Map.merge(attrs)
      |> Games.create_game()

    game
  end

  defp authenticated_admin_conn(conn) do
    admin = admin_user_fixture()
    {:ok, token} = Accounts.create_token(admin)

    put_req_header(conn, "authorization", "Bearer #{token.token}")
  end

  defp admin_user_fixture do
    {:ok, admin} =
      Accounts.create_user(%{
        email: "admin#{System.unique_integer([:positive])}@example.com",
        password: "supersecret",
        role: :admin
      })

    admin
  end
end
