defmodule GameStoreWeb.AdminLive.UploadHelpers do
  @moduledoc false

  import Phoenix.Component, only: [assign: 3]
  import Phoenix.LiveView

  def assign_uploaded_cover_image(socket, {:ok, uploaded_url}) do
    assign(socket, :uploaded_cover_image_url, uploaded_url)
  end

  def assign_uploaded_cover_image(socket, {:error, _reason}) do
    socket
    |> assign(:uploaded_cover_image_url, nil)
    |> put_flash(:error, "Cover image upload failed")
  end
end
