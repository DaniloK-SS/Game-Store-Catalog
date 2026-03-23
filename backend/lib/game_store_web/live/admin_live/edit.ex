defmodule GameStoreWeb.AdminLive.Edit do
  use GameStoreWeb, :live_view

  alias GameStore.Games
  alias GameStore.Games.Game
  alias GameStore.Cloudinary

  # Loads the existing game by ID and configures file upload.
  # Redirects to admin index if the game does not exist.
  def mount(%{"id" => id}, _session, socket) do
    case Games.get_game(id) do
      {:ok, game} ->
        changeset = Games.change_game(game)

        socket =
          socket
          |> assign(:game, game)
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

      {:error, :not_found} ->
        socket =
          socket
          |> put_flash(:error, "Game not found")
          |> redirect(to: ~p"/admin/games")

        {:ok, socket}
    end
  end

  # Validates on every keystroke using the existing game
  # as the base so unchanged fields keep their values.
  def handle_event("validate", %{"game" => params}, socket) do
    changeset =
      socket.assigns.game
      |> Games.change_game(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  # Cancels a pending file upload when the user clicks Remove.
  def handle_event("cancel_upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :cover_image, ref)}
  end

  # Handles form submission.
  # Uses update_game — not create_game — since this is an edit.
  # Falls back to the existing cover_image if no new image provided.
  def handle_event("save", %{"game" => params}, socket) do
    fallback_url = socket.assigns.game.cover_image
    cover_image_url = get_cover_image_url(socket, params["cover_image_url"] || fallback_url)
    game_params = Map.put(params, "cover_image", cover_image_url)

    case Games.update_game(socket.assigns.game, game_params) do
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

  # Fires automatically when a file finishes uploading to the server.
  # Immediately sends it to Cloudinary and stores the URL in assigns.
  def handle_progress(:cover_image, entry, socket) do
    if entry.done? do
      uploaded_url =
        consume_uploaded_entry(socket, entry, fn %{path: path} ->
          case Cloudinary.upload(path) do
            {:ok, url} -> {:ok, url}
            {:error, _} -> {:ok, nil}
          end
        end)

      {:noreply, assign(socket, :uploaded_cover_image_url, uploaded_url)}
    else
      {:noreply, socket}
    end
  end

  # Returns the Cloudinary URL if a file was uploaded,
  # otherwise returns the fallback URL unchanged.
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
        <h1 class="text-2xl font-bold text-gray-900">Edit Game</h1>
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

          <%!-- Cover Image — shows current image, supports upload or URL change --%>
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-2">Cover Image</label>

            <%= if @game.cover_image && @game.cover_image != "" do %>
              <div class="mb-3">
                <p class="text-xs text-gray-500 mb-1">Current image</p>
                <img
                  src={@game.cover_image}
                  class="w-32 h-20 object-cover rounded border border-gray-200"
                />
              </div>
            <% end %>

            <div class="mb-2">
              <label class="block text-xs text-gray-500 mb-1">Upload a new file</label>
              <.live_file_input
                upload={@uploads.cover_image}
                class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded file:border-0 file:text-sm file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
              />
            </div>

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

            <div class="mt-2">
              <label class="block text-xs text-gray-500 mb-1">Or paste a new image URL</label>
              <input
                type="text"
                name="game[cover_image_url]"
                placeholder={@game.cover_image}
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
            Save Changes
          </button>
        </.form>
      </div>
    </div>
    """
  end
end
