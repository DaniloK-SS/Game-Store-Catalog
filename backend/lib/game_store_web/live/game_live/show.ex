defmodule GameStoreWeb.GameLive.Show do
  use GameStoreWeb, :live_view

  alias GameStore.Games

  # Called when the page loads.
  # Fetches the game by ID from the URL params.
  # Redirects to the game list with an error message if the game is not found.
  def mount(%{"id" => id}, _session, socket) do
    case Games.get_game(id) do
      {:ok, game} ->
        {:ok, assign(socket, :game, game)}

      {:error, :not_found} ->
        socket =
          socket
          |> put_flash(:error, "Game not found")
          |> redirect(to: ~p"/games")

        {:ok, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto p-8">
      <%!-- Back link --%>
      <.link navigate={~p"/games"} class="text-blue-600 hover:underline text-sm mb-6 inline-block">
        &larr; Back to Games
      </.link>

      <div class="bg-white rounded-xl shadow-md overflow-hidden mt-4">
        <%!-- Cover Image --%>
        <div class="relative h-72 w-full">
          <img src={@game.cover_image} class="w-full h-full object-cover" />
          <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/80 to-transparent p-6">
            <h1 class="text-white text-3xl font-bold">{@game.title}</h1>
            <p class="text-gray-300">{@game.genre} / {@game.platform}</p>
          </div>
        </div>

        <%!-- Game Details --%>
        <div class="p-6">
          <%!-- Price and Stock row --%>
          <div class="flex items-center justify-between mb-4">
            <p class="text-3xl font-bold text-gray-900">${@game.price}</p>
            <%= if @game.in_stock do %>
              <span class="text-green-600 font-semibold text-sm px-3 py-1 bg-green-50 rounded-full">
                In Stock
              </span>
            <% else %>
              <span class="text-red-500 font-semibold text-sm px-3 py-1 bg-red-50 rounded-full">
                Out of Stock
              </span>
            <% end %>
          </div>

          <%!-- Description --%>
          <p class="text-gray-600 leading-relaxed mb-6">{@game.description}</p>

          <%!-- Details grid --%>
          <div class="grid grid-cols-2 gap-4 border-t border-gray-100 pt-4">
            <div>
              <p class="text-xs text-gray-400 uppercase tracking-wide">Publisher</p>
              <p class="text-gray-800 font-medium">{@game.publisher}</p>
            </div>
            <div>
              <p class="text-xs text-gray-400 uppercase tracking-wide">Release Year</p>
              <p class="text-gray-800 font-medium">{@game.release_year}</p>
            </div>
            <div>
              <p class="text-xs text-gray-400 uppercase tracking-wide">Platform</p>
              <p class="text-gray-800 font-medium">{@game.platform}</p>
            </div>
            <div>
              <p class="text-xs text-gray-400 uppercase tracking-wide">Genre</p>
              <p class="text-gray-800 font-medium">{@game.genre}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
