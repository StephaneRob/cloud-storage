defmodule CloudStorage.MixProject do
  use Mix.Project

  @source_url "https://github.com/StephaneRob/cloud-storage"
  @version "0.1.0"
  @elixir "~> 1.14"

  def project do
    [
      app: :cloud_storage,
      version: @version,
      elixir: @elixir,
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      docs: docs(),
      aliases: aliases(),
      package: package(),
      source_url: @source_url,
      description: "Direct upload cloud storage for Elixir application"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {CloudStorage.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      test: ["ecto.drop --quiet", "ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp deps do
    [
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:ecto_sql, "~> 3.9"},
      {:phoenix, "~> 1.6"},
      {:phoenix_html, "~> 3.2.0"},
      {:jason, "~> 1.4.0"},
      {:postgrex, ">= 0.0.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:mock, "~> 0.3.0", only: :test},
      {:ex_doc, "~> 0.29.1", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Stéphane Robino"],
      licenses: ["MIT"],
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE.md CHANGELOG.md),
      links: %{
        "Changelog" => "https://hexdocs.pm/cloud-storage/changelog.html",
        "GitHub" => @source_url
      }
    ]
  end

  def docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      homepage_url: @source_url,
      formatters: ["html"]
    ]
  end
end
