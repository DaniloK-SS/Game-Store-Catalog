defmodule GameStoreWeb.AdminLive.Users do
  use GameStoreWeb, :live_view

  alias GameStore.RenderAPI

  def mount(_params, session, socket) do
    token = session["render_token"]

    case RenderAPI.list_users(token) do
      {:ok, users} ->
        {:ok, assign(socket, users: users, error: nil, render_token: token)}

      {:error, _reason} ->
        {:ok, assign(socket, users: [], error: "Failed to load users", render_token: token)}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto p-8">
      <div class="flex items-center justify-between mb-8">
        <div>
          <h1 class="text-2xl font-bold text-gray-900">Users</h1>
          <p class="text-sm text-gray-500 mt-1">Manage user roles through the API</p>
        </div>

        <div class="flex gap-3">
          <.link
            navigate={~p"/admin/games"}
            class="text-sm text-gray-600 hover:text-gray-900 px-4 py-2 border border-gray-300 rounded"
          >
            Back to Games
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

      <%= if Phoenix.Flash.get(@flash, :info) do %>
        <div class="mb-4 p-3 bg-green-50 text-green-700 rounded text-sm">
          {Phoenix.Flash.get(@flash, :info)}
        </div>
      <% end %>

      <%= if Phoenix.Flash.get(@flash, :error) do %>
        <div class="mb-4 p-3 bg-red-50 text-red-700 rounded text-sm">
          {Phoenix.Flash.get(@flash, :error)}
        </div>
      <% end %>

      <%= if @error do %>
        <div class="mb-4 p-3 bg-red-50 text-red-700 rounded text-sm">
          {@error}
        </div>
      <% end %>

      <div class="mb-6 bg-white rounded-xl shadow border border-gray-100 p-6">
        <h2 class="text-lg font-semibold text-gray-900 mb-4">Create User</h2>

        <form phx-submit="create_user" class="grid grid-cols-1 md:grid-cols-4 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
            <input
              type="email"
              name="email"
              required
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
            <input
              type="password"
              name="password"
              required
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Role</label>
            <select
              name="role"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="user">user</option>
              <option value="admin">admin</option>
            </select>
          </div>

          <div class="flex items-end">
            <button
              type="submit"
              class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded"
            >
              Create User
            </button>
          </div>
        </form>
      </div>

      <div class="bg-white rounded-xl shadow border border-gray-100 overflow-hidden">
        <table class="w-full text-sm">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="text-left px-6 py-3 text-gray-500 font-medium">ID</th>
              <th class="text-left px-6 py-3 text-gray-500 font-medium">Email</th>
              <th class="text-left px-6 py-3 text-gray-500 font-medium">Role</th>
              <th class="text-left px-6 py-3 text-gray-500 font-medium">Actions</th>
            </tr>
          </thead>

          <tbody class="divide-y divide-gray-100">
            <%= for user <- @users do %>
              <tr class="hover:bg-gray-50">
                <td class="px-6 py-4 text-gray-600">{user["id"]}</td>
                <td class="px-6 py-4 font-medium text-gray-900">{user["email"]}</td>
                <td class="px-6 py-4 text-gray-600">{user["role"]}</td>
                <td class="px-6 py-4">
                  <%= if user["role"] == "admin" do %>
                    <button
                      phx-click="toggle_role"
                      phx-value-id={user["id"]}
                      phx-value-role="user"
                      class="text-sm text-red-600 hover:text-red-800"
                    >
                      Make User
                    </button>
                  <% else %>
                    <button
                      phx-click="toggle_role"
                      phx-value-id={user["id"]}
                      phx-value-role="admin"
                      class="text-sm text-blue-600 hover:text-blue-800"
                    >
                      Make Admin
                    </button>
                  <% end %>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  def handle_event("toggle_role", %{"id" => id, "role" => role}, socket) do
    token = socket.assigns.render_token

    case RenderAPI.update_user_role(token, id, role) do
      {:ok, _updated_user} ->
        refresh_users(socket, "User role updated successfully")

      {:error, error} ->
        {:noreply, put_flash(socket, :error, "Failed to update role: #{inspect(error)}")}
    end
  end

  def handle_event("create_user", params, socket) do
    token = socket.assigns.render_token
    attrs = user_attrs_from_params(params)

    case RenderAPI.create_user(token, attrs) do
      {:ok, _user} ->
        refresh_users(socket, "User created successfully")

      {:error, {:validation, _errors}} ->
        {:noreply, put_flash(socket, :error, "Failed to create user. Check the input values.")}

      {:error, error} ->
        {:noreply, put_flash(socket, :error, "Failed to create user: #{inspect(error)}")}
    end
  end

  defp refresh_users(socket, success_message) do
    token = socket.assigns.render_token

    case RenderAPI.list_users(token) do
      {:ok, users} ->
        socket =
          socket
          |> put_flash(:info, success_message)
          |> assign(:users, users)

        {:noreply, socket}

      {:error, _reason} ->
        socket =
          socket
          |> put_flash(:error, "#{success_message}, but failed to refresh users list")

        {:noreply, socket}
    end
  end

  defp user_attrs_from_params(params) do
    %{
      "email" => params["email"],
      "password" => params["password"],
      "role" => params["role"]
    }
  end
end
