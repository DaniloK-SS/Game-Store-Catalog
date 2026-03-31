defmodule GameStore.ImageService do
  @callback extract_public_id(String.t()) :: {:ok, String.t()} | :error
  @callback delete(String.t()) :: :ok | {:error, term()}
end
