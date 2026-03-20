defmodule GameStoreWeb.AdminLive.Edit do
  use GameStoreWeb, :live_view

  alias GameStore.Games
  alias GameStore.Games.Game

  # Loads the existing game by ID on mount.
  # Redirects to admin index if the game does not exist.
  # Pre-populates the form with the game's current values.
  def mount(%{"id" => id}, _session, socket) do
    case Games.get_game(id) do
      {:ok, game} ->
        changeset = Games.change_game(game)

        socket =
          socket
          |> assign(:game, game)
          |> assign(:form, to_form(changeset))

        {:ok, socket}

      {:error, :not_found} ->
        socket =
          socket
          |> put_flash(:error, "Game not found")
          |> redirect(to: ~p"/admin/games")

        {:ok, socket}
    end
  end

  # Validates input on every change without saving.
  # Uses the existing game struct so unchanged fields
  # keep their current values during validation.
  def handle_event("validate", %{"game" => params}, socket) do
    changeset =
      socket.assigns.game
      |> Games.change_game(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  # Handles form submission.
  # Updates the existing game with new params.
  # On success redirects to admin index with flash message.
  # On failure re-renders form with inline errors.
  def handle_event("save", %{"game" => params}, socket) do
    case Games.update_game(socket.assigns.game, params) do
      {:ok, _game} ->
        socket =
          socket
          |> put_flash(:info, "Game updated successfully")
          |> redirect(to: ~p"/admin/games")

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto p-8">

      <%!-- Header --%>
      <div class="flex items-center justify-between mb-8">
        <h1 class="text-2xl font-bold text-gray-900">Edit Game</h1>
        <.link
          navigate={~p"/admin/games"}
          class="text-sm text-gray-600 hover:text-gray-900"
        >
          &larr; Back to Admin
        </.link>
      </div>

      <%!-- Form --%>
      <div class="bg-white rounded-xl shadow border border-gray-100 p-6">
        <.form for={@form} phx-change="validate" phx-submit="save">

          <%!-- Title --%>
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Title</label>
            <.input field={@form[:title]} type="text" placeholder="Game title" />
          </div>

          <%!-- Genre and Platform row --%>
          <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Genre</label>
              <.input field={@form[:genre]} type="select" options={[
                "Action", "RPG", "Racing", "Adventure",
                "Horror", "Shooter", "Puzzle", "Survival"
              ]} prompt="Select genre" />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Platform</label>
              <.input field={@form[:platform]} type="select" options={[
                "PC", "PlayStation", "Xbox", "Nintendo Switch"
              ]} prompt="Select platform" />
            </div>
          </div>

          <%!-- Price and Release Year row --%>
          <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Price</label>
              <.input field={@form[:price]} type="text" placeholder="29.99" />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Release Year</label>
              <.input field={@form[:release_year]} type="number" placeholder="2024" />
            </div>
          </div>

          <%!-- Publisher --%>
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Publisher</label>
            <.input field={@form[:publisher]} type="text" placeholder="Publisher name" />
          </div>

          <%!-- Cover Image --%>
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Cover Image URL</label>
            <.input field={@form[:cover_image]} type="text" placeholder="https://..." />
          </div>

          <%!-- Description --%>
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
            <.input field={@form[:description]} type="textarea" placeholder="Game description..." />
          </div>

          <%!-- In Stock and Featured row --%>
          <div class="flex gap-6 mb-6">
            <label class="flex items-center gap-2 text-sm text-gray-700">
              <.input field={@form[:in_stock]} type="checkbox" />
              In Stock
            </label>
            <label class="flex items-center gap-2 text-sm text-gray-700">
              <.input field={@form[:featured]} type="checkbox" />
              Featured
            </label>
          </div>

          <%!-- Submit --%>
          <button
            type="submit"
            class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded"
          >
            Save Changes
          </button>

        </.form>
      </div>
    </div>
    """
  end
end
