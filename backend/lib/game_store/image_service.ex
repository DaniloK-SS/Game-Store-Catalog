defmodule GameStore.ImageService do
  @moduledoc """
  Behaviour for services that manage externally stored images.
  """

  @callback upload(String.t()) :: {:ok, String.t()} | {:error, term()}
  @callback extract_public_id(String.t()) :: {:ok, String.t()} | :error
  @callback delete(String.t()) :: :ok | {:error, term()}
end
