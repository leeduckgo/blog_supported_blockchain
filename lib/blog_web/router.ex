defmodule BlogWeb.Router do
  use BlogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["urlencoded","json"]
    plug CORSPlug, [origin: "http://localhost"]
  end

  pipeline :auth do
    plug(Auth.AuthAccessPipeline)
  end

  scope "/elixir_web", BlogWeb do
    pipe_through([:browser])
    get("/articles/:id", PageController, :show)
  end

  # scope "/ycy", BlogWeb do
  #   pipe_through([:browser])
  #   get("/messages", YcyController, :show)
  # end

  scope "/api/v1", BlogWeb do
    pipe_through([:browser, :api])
    post("/articles", ArticleController, :show)
    post("/test", ArticleController, :test)
    resources("/sessions", SessionController, only: [:new, :create])
    get("/articles/:id", ArticleController, :show) # get an article by id
    get("/ycy/messages" ,YcyController, :show)
  end

  scope "/api/v1", BlogWeb do
    pipe_through([:browser, :api, :auth])
    get("/sessions/logout", SessionController, :delete)
    get("/users/:id", UserController, :show)
    get("/", PageController, :index)
    get("/users/",UserController, :load_current_user)

    post("/articles/create" , ArticleController, :create) # create an article by id
  end

  # Other scopes may use custom stacks.
  # scope "/api", BlogWeb do
  #   pipe_through :api
  # end
end
