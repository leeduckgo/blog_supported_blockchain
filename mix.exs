defmodule Blog.Mixfile do
  use Mix.Project

  def project do
    [
      app: :blog,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Blog.Application, []},
      extra_applications: [:logger, :runtime_tools]
      # applications: [:corsica]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # scrivener
      {:scrivener_ecto, "~> 2.2.0"},
      {:jason, ">=0.0.1"},
      {:cors_plug, "~> 2.0"},
      # {:corsica, "~> 1.0"},
      {:guardian, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 1.1"},
      {:phoenix, github: "phoenixframework/phoenix", branch: "v1.4", override: true},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.13", github: "phoenixframework/phoenix_html", override: true},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:ecto_enum, "~> 1.0"},
      {:earmark, ">= 0.0.0"},
      {:plug_cowboy, "~> 1.0"},
      {:phoenix_live_view,
       github: "phoenixframework/phoenix_live_view",
       ref: "b94f0d3a1299fcc0fb3e6ea1bdd298e9c4d1571c"},
      {:ecto_sql, "~> 3.0"},
      {:poison, "~> 3.1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
      # "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
