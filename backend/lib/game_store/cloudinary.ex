defmodule GameStore.Cloudinary do
  @doc """
  Uploads a file to Cloudinary using an unsigned upload preset.
  Returns {:ok, url} on success or {:error, reason} on failure.
  """
  def upload(file_path) do
    config = Application.get_env(:game_store, :cloudinary)
    cloud_name = config[:cloud_name]
    upload_preset = config[:upload_preset]

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
end
