defmodule GameStoreWeb.FallbackController do
  use GameStoreWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: GameStoreWeb.ErrorJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: GameStoreWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :cannot_demote_self}) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "You cannot demote yourself"})
  end
end
