defmodule GameStoreWeb.AdminLive.New do
  use GameStoreWeb, :live_view

  alias GameStore.Games
  alias GameStore.Games.Game

  # On mount we create an empty changeset and configure
  # the file upload. allow_upload tells LiveView to accept
  # image files up to 10MB, max 1 file at a time.
  def mount(_params, _session, socket) do
    changeset = Games.change_game(%Game{})

    socket =
      socket
      |> assign(:changeset, changeset)
      |> assign(:form, to_form(changeset))
      |> assign(:uploaded_cover_image_url, nil)
      |> allow_upload(:cover_image,
        accept: ~w(.jpg .jpeg .png .webp),
        max_entries: 1,
        max_file_size: 10_000_000,
        auto_upload: true,
        progress: &handle_progress/3
      )

    {:ok, socket}
  end

  # Validates form input on every keystroke without saving.
  def handle_event("validate", %{"game" => params}, socket) do
    changeset =
      %Game{}
      |> Games.change_game(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  # Handles form submission.
  # First checks if a file was uploaded — if yes, uploads to
  # Cloudinary and uses the returned URL as cover_image.
  # If no file uploaded, falls back to the text URL field.
  def handle_event("save", %{"game" => params}, socket) do
    cover_image_url = get_cover_image_url(socket, params["cover_image_url"])
    game_params = Map.put(params, "cover_image", cover_image_url)

    case Games.create_game(game_params) do
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

  def handle_event("cancel_upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :cover_image, ref)}
  end

  def handle_progress(:cover_image, entry, socket) do
    if entry.done? do
      uploaded_url =
        consume_uploaded_entry(socket, entry, fn %{path: path} ->
          case GameStore.Cloudinary.upload(path) do
            {:ok, url} -> {:ok, url}
            {:error, _} -> {:ok, nil}
          end
        end)

      {:noreply, assign(socket, :uploaded_cover_image_url, uploaded_url)}
    else
      {:noreply, socket}
    end
  end

  # If a file was uploaded consume it, upload to Cloudinary
  # and return the secure URL.
  # If no file was uploaded fall back to the manually typed URL.
  defp get_cover_image_url(socket, fallback_url) do
    cond do
      socket.assigns.uploaded_cover_image_url != nil ->
        socket.assigns.uploaded_cover_image_url

      fallback_url != "" and fallback_url != nil ->
        fallback_url

      true ->
        nil
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto p-8">
      <div class="flex items-center justify-between mb-8">
        <h1 class="text-2xl font-bold text-gray-900">Add New Game</h1>
        <.link navigate={~p"/admin/games"} class="text-sm text-gray-600 hover:text-gray-900">
          &larr; Back to Admin
        </.link>
      </div>

      <div class="bg-white rounded-xl shadow border border-gray-100 p-6">
        <.form for={@form} phx-change="validate" phx-submit="save">
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Title</label>
            <.input field={@form[:title]} type="text" placeholder="Game title" />
          </div>

          <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Genre</label>
              <.input
                field={@form[:genre]}
                type="select"
                options={[
                  "Action",
                  "RPG",
                  "Racing",
                  "Adventure",
                  "Horror",
                  "Shooter",
                  "Puzzle",
                  "Survival"
                ]}
                prompt="Select genre"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Platform</label>
              <.input
                field={@form[:platform]}
                type="select"
                options={[
                  "PC",
                  "PlayStation",
                  "Xbox",
                  "Nintendo Switch"
                ]}
                prompt="Select platform"
              />
            </div>
          </div>

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

          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Publisher</label>
            <.input field={@form[:publisher]} type="text" placeholder="Publisher name" />
          </div>

          <%!-- Cover Image — supports both file upload and URL --%>
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-2">Cover Image</label>

            <%!-- File upload input --%>
            <div class="mb-2">
              <label class="block text-xs text-gray-500 mb-1">Upload a file</label>
              <.live_file_input
                upload={@uploads.cover_image}
                class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded file:border-0 file:text-sm file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
              />
            </div>

            <%!-- Show upload preview if file selected --%>
            <%= for entry <- @uploads.cover_image.entries do %>
              <div class="flex items-center gap-2 text-sm text-gray-600 mb-2">
                <.live_img_preview entry={entry} class="w-16 h-16 object-cover rounded" />
                <span>{entry.client_name}</span>
                <button
                  type="button"
                  phx-click="cancel_upload"
                  phx-value-ref={entry.ref}
                  class="text-red-500 hover:text-red-700 text-xs"
                >
                  Remove
                </button>
              </div>
            <% end %>

            <%!-- Fallback URL input --%>
            <div class="mt-2">
              <label class="block text-xs text-gray-500 mb-1">Or paste an image URL</label>
              <input
                type="text"
                name="game[cover_image_url]"
                placeholder="https://..."
                class="w-full border border-gray-300 rounded px-3 py-2 text-sm"
              />
            </div>
          </div>

          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
            <.input field={@form[:description]} type="textarea" placeholder="Game description..." />
          </div>

          <div class="flex gap-6 mb-6">
            <label class="flex items-center gap-2 text-sm text-gray-700">
              <.input field={@form[:in_stock]} type="checkbox" /> In Stock
            </label>
            <label class="flex items-center gap-2 text-sm text-gray-700">
              <.input field={@form[:featured]} type="checkbox" /> Featured
            </label>
          </div>

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
