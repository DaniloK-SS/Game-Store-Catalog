defmodule GameStoreWeb.GameLive.Index do
  use GameStoreWeb, :live_view

  alias GameStore.Games

  # Called when the LiveView first loads.
  # Loads all games with no filters and sets up empty filter state.
  def mount(_params, _session, socket) do
    games = Games.list_games()

    socket =
      socket
      |> assign(:games, games)
      |> assign(:platform, "")
      |> assign(:genre, "")
      |> assign(:in_stock, "")

    {:ok, socket}
  end

  # Called when filter form changes.
  # Rebuilds the filter params and re-queries the context.
  def handle_event("filter", params, socket) do
    filter_params =
      %{}
      |> maybe_add("platform", params["platform"])
      |> maybe_add("genre", params["genre"])
      |> maybe_add("in_stock", params["in_stock"])

    games = Games.list_games(filter_params)

    socket =
      socket
      |> assign(:games, games)
      |> assign(:platform, params["platform"] || "")
      |> assign(:genre, params["genre"] || "")
      |> assign(:in_stock, params["in_stock"] || "")

    {:noreply, socket}
  end

  # Only adds a filter to the params map if a real value was selected.
  # Ignores empty strings so the context treats them as no filter.
  defp maybe_add(params, _key, ""), do: params
  defp maybe_add(params, key, value), do: Map.put(params, key, value)

  def render(assigns) do
    ~H"""
    <div class="flex min-h-screen bg-white">

      <%!-- Filters Sidebar --%>
      <aside class="w-64 p-6 border-r border-gray-200 shrink-0">
        <h2 class="text-lg font-semibold mb-4 pb-2 border-b border-gray-200">Filters Panel</h2>

        <form phx-change="filter">
          <%!-- Platform Filter --%>
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Platform</label>
            <select name="platform" class="w-full border border-gray-300 rounded px-3 py-2 text-sm">
              <option value="">All</option>
              <option value="PC" selected={@platform == "PC"}>PC</option>
              <option value="PlayStation" selected={@platform == "PlayStation"}>PlayStation</option>
              <option value="Xbox" selected={@platform == "Xbox"}>Xbox</option>
            </select>
          </div>

          <%!-- Genre Filter --%>
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Genre</label>
            <select name="genre" class="w-full border border-gray-300 rounded px-3 py-2 text-sm">
              <option value="">All</option>
              <option value="Action" selected={@genre == "Action"}>Action</option>
              <option value="RPG" selected={@genre == "RPG"}>RPG</option>
              <option value="Racing" selected={@genre == "Racing"}>Racing</option>
              <option value="Adventure" selected={@genre == "Adventure"}>Adventure</option>
              <option value="Horror" selected={@genre == "Horror"}>Horror</option>
              <option value="Shooter" selected={@genre == "Shooter"}>Shooter</option>
              <option value="Puzzle" selected={@genre == "Puzzle"}>Puzzle</option>
              <option value="Survival" selected={@genre == "Survival"}>Survival</option>
            </select>
          </div>

          <%!-- Stock Filter --%>
          <div class="mb-6">
            <label class="block text-sm font-medium text-gray-700 mb-1">Stock</label>
            <label class="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                name="in_stock"
                value="true"
                checked={@in_stock == "true"}
              />
              In Stock Only
            </label>
          </div>

          <%!-- Clear Filters --%>
          <button
            type="button"
            phx-click="filter"
            phx-value-platform=""
            phx-value-genre=""
            phx-value-in_stock=""
            class="w-full bg-gray-100 hover:bg-gray-200 text-gray-700 text-sm py-2 px-4 rounded"
          >
            Clear Filters
          </button>
        </form>
      </aside>

      <%!-- Main Content --%>
      <main class="flex-1 p-8">

        <%!-- Featured Section --%>
        <section class="mb-8">
          <h1 class="text-2xl font-bold mb-4">Featured Games</h1>
          <div class="grid grid-cols-3 gap-4">
            <%= for game <- Enum.filter(@games, & &1.featured) do %>
              <.link navigate={~p"/games/#{game.id}"}>
                <div class="relative rounded-lg overflow-hidden h-48 cursor-pointer">
                  <img src={game.cover_image} class="w-full h-full object-cover" />
                  <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/80 to-transparent p-3">
                    <p class="text-white font-semibold"><%= game.title %></p>
                    <p class="text-gray-300 text-sm"><%= game.genre %> / <%= game.platform %></p>
                  </div>
                </div>
              </.link>
            <% end %>
          </div>
        </section>

        <%!-- Games Grid --%>
        <section>
          <div class="grid grid-cols-3 gap-6">
            <%= for game <- @games do %>
              <.link navigate={~p"/games/#{game.id}"}>
                <div class="bg-white rounded-lg shadow border border-gray-100 overflow-hidden hover:shadow-md transition-shadow cursor-pointer">
                  <img src={game.cover_image} class="w-full h-48 object-cover" />
                  <div class="p-4">
                    <h3 class="font-semibold text-gray-900"><%= game.title %></h3>
                    <p class="text-sm text-gray-500"><%= game.genre %></p>
                    <p class="text-sm text-gray-500"><%= game.platform %></p>
                    <p class="text-lg font-bold text-gray-900 mt-2">$<%= game.price %></p>
                    <%= if game.in_stock do %>
                      <p class="text-sm text-green-600 font-medium">In Stock</p>
                    <% else %>
                      <p class="text-sm text-red-500 font-medium">Out of Stock</p>
                    <% end %>
                  </div>
                </div>
              </.link>
            <% end %>
          </div>
        </section>

      </main>
    </div>
    """
  end
end
