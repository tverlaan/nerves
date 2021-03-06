defmodule SimpleAppV1.Fixture do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi3"

  def project do
    [app: :simple_app_v1,
     version: "0.1.0",
     archives: [nerves_bootstrap: "~> 0.1"],
     target: @target,
     aliases: aliases(),
     deps: deps()]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [{:system_v1, path: "../system_v1"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths",    "nerves.loadpaths"]]
  end

end
