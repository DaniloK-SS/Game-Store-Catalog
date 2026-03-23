defmodule GameStoreWeb.AdminLive.Index do
  use GameStoreWeb, :live_view

  alias GameStore.Games

  # Loads all games on mount with no filters.
  # Admin sees everything regardless of stock status.
  def mount(_params, _session, socket) do
    games = Games.list_games()
    {:ok, assign(socket, :games, games)}
  end

  # Handles the delete button click for a game.
  # Fetches the game first to make sure it exists,
  # then deletes it and refreshes the games list.
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, game} = Games.get_game(id)
    Games.delete_game(game)
    games = Games.list_games()

    socket =
      socket
      |> put_flash(:info, "Game deleted successfully")
      |> assign(:games, games)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto p-8">
      <%!-- Header --%>
      <div class="flex items-center justify-between mb-8">
        <div>
          <h1 class="text-2xl font-bold text-gray-900">Admin Panel</h1>
          <p class="text-sm text-gray-500 mt-1">Manage your game catalog</p>
        </div>
        <div class="flex gap-3">
          <.link
            navigate={~p"/games"}
            class="text-sm text-gray-600 hover:text-gray-900 px-4 py-2 border border-gray-300 rounded"
          >
            View Public Site
          </.link>
          <.link
            navigate={~p"/admin/games/new"}
            class="text-sm text-white bg-blue-600 hover:bg-blue-700 px-4 py-2 rounded"
          >
            + Add New Game
          </.link>
          <.link
            href={~p"/admin/logout"}
            method="delete"
            class="text-sm text-red-600 hover:text-red-800 px-4 py-2 border border-red-200 rounded"
          >
            Logout
          </.link>
        </div>
      </div>

      <%!-- Flash message --%>
      <%= if Phoenix.Flash.get(@flash, :info) do %>
        <div class="mb-4 p-3 bg-green-50 text-green-700 rounded text-sm">
          {Phoenix.Flash.get(@flash, :info)}
        </div>
      <% end %>

      <%!-- Games Table --%>
      <div class="bg-white rounded-xl shadow border border-gray-100 overflow-hidden">
        <table class="w-full text-sm">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="text-left px-6 py-3 text-gray-500 font-medium">Game</th>
              <th class="text-left px-6 py-3 text-gray-500 font-medium">Genre</th>
              <th class="text-left px-6 py-3 text-gray-500 font-medium">Platform</th>
              <th class="text-left px-6 py-3 text-gray-500 font-medium">Price</th>
              <th class="text-left px-6 py-3 text-gray-500 font-medium">Stock</th>
              <th class="text-left px-6 py-3 text-gray-500 font-medium">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <%= for game <- @games do %>
              <tr class="hover:bg-gray-50">
                <td class="px-6 py-4">
                  <div class="flex items-center gap-3">
                    <img src={game.cover_image} class="w-10 h-10 rounded object-cover" />
                    <span class="font-medium text-gray-900">{game.title}</span>
                  </div>
                </td>
                <td class="px-6 py-4 text-gray-600">{game.genre}</td>
                <td class="px-6 py-4 text-gray-600">{game.platform}</td>
                <td class="px-6 py-4 text-gray-600">${game.price}</td>
                <td class="px-6 py-4">
                  <%= if game.in_stock do %>
                    <span class="text-green-600 font-medium">In Stock</span>
                  <% else %>
                    <span class="text-red-500 font-medium">Out of Stock</span>
                  <% end %>
                </td>
                <td class="px-6 py-4">
                  <div class="flex gap-3">
                    <.link
                      navigate={~p"/admin/games/#{game.id}/edit"}
                      class="text-blue-600 hover:underline"
                    >
                      Edit
                    </.link>
                    <button
                      phx-click="delete"
                      phx-value-id={game.id}
                      data-confirm="Are you sure you want to delete this game?"
                      class="text-red-500 hover:underline"
                    >
                      Delete
                    </button>
                  </div>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end
end
