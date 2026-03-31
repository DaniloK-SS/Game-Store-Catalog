defmodule GameStore.Cloudinary do
  @behaviour GameStore.ImageService
  @doc """
  Uploads a file to Cloudinary using an unsigned upload preset.
  Returns {:ok, url} on success or {:error, reason} on failure.
  """
  def upload(file_path) do
    cloud_name = config()[:cloud_name]
    upload_preset = config()[:upload_preset]

    url = "https://api.cloudinary.com/v1_1/#{cloud_name}/image/upload"

    # Read file contents into memory
    {:ok, file_contents} = File.read(file_path)
    filename = Path.basename(file_path)
    content_type = MIME.from_path(file_path)

    # Build multipart body with correct content length
    multipart =
      Multipart.new()
      |> Multipart.add_part(Multipart.Part.text_field(upload_preset, "upload_preset"))
      |> Multipart.add_part(
        Multipart.Part.file_content_field(filename, file_contents, :file,
          filename: filename,
          content_type: content_type
        )
      )

    content_length = Multipart.content_length(multipart)
    content_type_header = Multipart.content_type(multipart, "multipart/form-data")

    case Req.post(url,
           headers: [
             {"content-type", content_type_header},
             {"content-length", to_string(content_length)}
           ],
           body: Multipart.body_stream(multipart),
           receive_timeout: 120_000,
           retry: false
         ) do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body["secure_url"]}

      {:ok, %{status: status, body: body}} ->
        {:error, "Cloudinary error #{status}: #{inspect(body)}"}

      {:error, reason} ->
        {:error, "Upload failed: #{inspect(reason)}"}
    end
  end

  @impl true
  def extract_public_id(nil), do: :error
  @impl true
  def extract_public_id(""), do: :error

  @impl true
  def extract_public_id(url) when is_binary(url) do
    case String.split(url, "/upload/", parts: 2) do
      [_left, right] ->
        right
        |> strip_version()
        |> strip_extension()
        |> case do
          "" -> :error
          public_id -> {:ok, public_id}
        end

      _ ->
        :error
    end
  end

  @impl true
  def delete(public_id) when is_binary(public_id) do
    cloud_name = config()[:cloud_name]
    api_key = config()[:api_key]
    api_secret = config()[:api_secret]
    timestamp = DateTime.utc_now() |> DateTime.to_unix() |> Integer.to_string()

    signature =
      :crypto.hash(:sha, "public_id=#{public_id}&timestamp=#{timestamp}#{api_secret}")
      |> Base.encode16(case: :lower)

    url = "https://api.cloudinary.com/v1_1/#{cloud_name}/image/destroy"

    form = [
      {"public_id", public_id},
      {"timestamp", timestamp},
      {"api_key", api_key},
      {"signature", signature}
    ]

    case Req.post(url,
           headers: [{"content-type", "application/x-www-form-urlencoded"}],
           form: form
         ) do
      {:ok, %{status: 200, body: %{"result" => result}}} when result in ["ok", "not found"] ->
        :ok

      {:ok, %{status: 200, body: body}} ->
        {:error, "Cloudinary delete failed: #{inspect(body)}"}

      {:ok, %{status: status, body: body}} ->
        {:error, "Cloudinary error #{status}: #{inspect(body)}"}

      {:error, reason} ->
        {:error, "Delete failed: #{inspect(reason)}"}
    end
  end

  defp strip_version(path) do
    case String.split(path, "/", parts: 2) do
      [<<"v", rest::binary>>, remaining] when rest != "" ->
        remaining

      _ ->
        path
    end
  end

  defp strip_extension(path) do
    case String.split(path, "/") do
      [] ->
        ""

      parts ->
        {last, rest} = List.pop_at(parts, -1)
        Path.join(rest ++ [Path.rootname(last)])
    end
  end

  defp config do
    Application.fetch_env!(:game_store, :cloudinary)
  end
end
