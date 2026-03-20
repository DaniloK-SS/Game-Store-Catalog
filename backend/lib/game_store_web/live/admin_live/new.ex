defmodule GameStoreWeb.AdminLive.New do
  use GameStoreWeb, :live_view

  alias GameStore.Games
  alias GameStore.Games.Game
  alias Ecto.Changeset

  # On mount we create an empty changeset to back the form.
  # The form needs a changeset from the very start so it
  # knows the field names, types, and any initial errors.
  def mount(_params, _session, socket) do
    changeset = Games.change_game(%Game{})

    socket =
      socket
      |> assign(:changeset, changeset)
      |> assign(:form, to_form(changeset))

    {:ok, socket}
  end

  # Fires on every keystroke due to phx-change on the form.
  # Validates the current input without saving to the database.
  # This gives the user live inline feedback as they type.
  def handle_event("validate", %{"game" => params}, socket) do
    changeset =
      %Game{}
      |> Games.change_game(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  # Fires when the form is submitted.
  # Attempts to create the game — on success redirects to the
  # admin index with a flash message. On failure re-renders the
  # form with the changeset errors shown inline.
  def handle_event("save", %{"game" => params}, socket) do
    case Games.create_game(params) do
      {:ok, _game} ->
        socket =
          socket
          |> put_flash(:info, "Game created successfully")
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
        <h1 class="text-2xl font-bold text-gray-900">Add New Game</h1>
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
            Create Game
          </button>

        </.form>
      </div>
    </div>
    """
  end
end
