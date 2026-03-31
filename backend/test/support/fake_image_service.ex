defmodule GameStore.FakeImageService do
  @behaviour GameStore.ImageService

  @impl true
  def extract_public_id(nil), do: :error

  @impl true
  def extract_public_id(""), do: :error

  @impl true
  def extract_public_id("bad-url"), do: :error

  @impl true
  def extract_public_id(url) when is_binary(url) do
    {:ok, url}
  end

  @impl true
  def delete("delete-fails"), do: {:error, :delete_failed}
  def delete(_public_id), do: :ok
end
