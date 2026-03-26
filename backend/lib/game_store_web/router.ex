defmodule GameStoreWeb.Router do
  use GameStoreWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GameStoreWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GameStoreWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug GameStoreWeb.Plugs.RequireAdmin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug GameStoreWeb.Plugs.RequireApiAuth
  end

  # Public routes
  scope "/", GameStoreWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/games", GameLive.Index, :index
    live "/games/:id", GameLive.Show, :show
  end

  # Public API — anyone can read games
  scope "/api", GameStoreWeb do
    pipe_through :api

    get "/games", GameController, :index
    get "/games/:id", GameController, :show

    # Login — anyone can attempt, returns token only if admin
    post "/sessions", Api.SessionController, :create
  end

  # Protected API — only admins with a valid token
  scope "/api", GameStoreWeb do
    pipe_through :api_auth

    post "/games", GameController, :create
    put "/games/:id", GameController, :update
    delete "/games/:id", GameController, :delete

    # Logout
    delete "/sessions", Api.SessionController, :delete
  end

  # Admin login page — no auth required to reach the login form
  scope "/admin", GameStoreWeb do
    pipe_through :browser

    get "/login", AdminSessionController, :new
    post "/login", AdminSessionController, :create
    delete "/logout", AdminSessionController, :delete
  end

  # Admin panel — requires admin session
  scope "/admin", GameStoreWeb do
    pipe_through :admin

    live "/games", AdminLive.Index, :index
    live "/games/new", AdminLive.New, :new
    live "/games/:id/edit", AdminLive.Edit, :edit
  end

  if Application.compile_env(:game_store, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GameStoreWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
