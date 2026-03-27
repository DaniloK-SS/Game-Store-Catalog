defmodule GameStore.RenderAPI do
  @moduledoc """
  Small client for talking to the deployed Render API.

  For now we only use it for admin login.
  Later it can also be used for listing users and updating roles.
  """

  @base_url "https://game-store-catalog.onrender.com/api"

  @doc """
  Sends login request to the deployed API.

  Returns:
    - {:ok, token} on success
    - {:error, :invalid_credentials} for 401
    - {:error, :forbidden} for 403
    - {:error, :request_failed} for other failures
  """
  def login(email, password) do
    case Req.post(
           "#{@base_url}/sessions",
           json: %{
             email: email,
             password: password
           }
         ) do
      {:ok, %{status: 201, body: %{"token" => token}}} ->
        {:ok, token}

      {:ok, %{status: 401}} ->
        {:error, :invalid_credentials}

      {:ok, %{status: 403}} ->
        {:error, :forbidden}

      {:ok, _response} ->
        {:error, :request_failed}

      {:error, _reason} ->
        {:error, :request_failed}
    end
  end

  def list_users(token) do
    case Req.get(
           "#{@base_url}/users",
           headers: [
             {"authorization", "Bearer #{token}"}
           ]
         ) do
      {:ok, %{status: 200, body: %{"data" => users}}} ->
        {:ok, users}

      {:ok, %{status: 401}} ->
        {:error, :unauthorized}

      {:ok, _} ->
        {:error, :request_failed}

      {:error, _} ->
        {:error, :request_failed}
    end
  end

  def update_user_role(token, user_id, role) do
  case Req.patch(
         "#{@base_url}/users/#{user_id}/role",
         headers: [
           {"authorization", "Bearer #{token}"}
         ],
         json: %{
           role: role
         }
       ) do
    {:ok, %{status: 200, body: %{"data" => user}}} ->
      {:ok, user}

    {:ok, %{status: 403, body: %{"error" => error}}} ->
      {:error, error}

    {:ok, %{status: 404}} ->
      {:error, :not_found}

    {:ok, %{status: 422}} ->
      {:error, :invalid_role}

    {:ok, %{status: 401}} ->
      {:error, :unauthorized}

    {:ok, _response} ->
      {:error, :request_failed}

    {:error, _reason} ->
      {:error, :request_failed}
  end
end

# def create_user(token, attrs) do
#   case Req.post(
#          "#{@base_url}/users",
#          headers: [
#            {"authorization", "Bearer #{token}"}
#          ],
#          json: %{
#            user: attrs
#          }
#        ) do
#     {:ok, %{status: 201, body: %{"data" => user}}} ->
#       {:ok, user}

#     {:ok, %{status: 422, body: %{"errors" => errors}}} ->
#       {:error, {:validation, errors}}

#     {:ok, %{status: 401}} ->
#       {:error, :unauthorized}

#     {:ok, _response} ->
#       {:error, :request_failed}

#     {:error, _reason} ->
#       {:error, :request_failed}
#   end
# end


def create_user(token, attrs) do
  case Req.post(
         "#{@base_url}/users",
         headers: [
           {"authorization", "Bearer #{token}"}
         ],
         json: %{
           user: attrs
         }
       ) do
    {:ok, %{status: status, body: body}} ->
      IO.inspect({status, body}, label: "CREATE USER RESPONSE")

      case status do
        201 -> {:ok, body["data"]}
        422 -> {:error, {:validation, body}}
        401 -> {:error, :unauthorized}
        _ -> {:error, {:unexpected, status, body}}
      end

    {:error, reason} ->
      IO.inspect(reason, label: "REQUEST ERROR")
      {:error, :request_failed}
  end
end
end
