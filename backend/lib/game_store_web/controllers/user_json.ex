defmodule GameStoreWeb.UserJSON do
  alias GameStore.Accounts.User

  def index(%{users: users}) do
    %{data: Enum.map(users, &user_data/1)}
  end

  def show(%{user: user}) do
    %{data: user_data(user)}
  end

  defp user_data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      role: Atom.to_string(user.role)
    }
  end
end
