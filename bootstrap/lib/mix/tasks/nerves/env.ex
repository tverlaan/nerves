defmodule Mix.Tasks.Nerves.Env do
  use Mix.Task
  import Mix.Nerves.Bootstrap.Utils

  @switches [info: :boolean]

  def run(argv) do
    debug_info "Nerves Env Start"
    {opts, _, _} = OptionParser.parse(argv, switches: @switches)
    unless Code.ensure_compiled?(Nerves.Env) do
      Mix.Tasks.Deps.Compile.run ["nerves", "--include-children"]
    end
    # Env moved to :nerves, try to start it otherwise, compile
    #  :nerves_system and call initialize
    try do
      Nerves.Env.start()
    rescue
      UndefinedFunctionError ->
        unless Code.ensure_compiled?(Nerves.Env) do
          Mix.Tasks.Deps.Compile.run ["nerves_system", "--include-children"]
        end
        Nerves.Env.initialize()
    end
    debug_info "Nerves Env End"
    if opts[:info], do: print_env()
  end

  def print_env() do
    Mix.shell.info """
    ---------------------------
    Nerves Environment Packages
    ---------------------------
    """
    Nerves.Env.packages
    |> Enum.each(&print_pkg/1)
    System.put_env("NERVES_DEBUG", "1")
    Mix.Tasks.Nerves.Loadpaths.run []
  end

  defp print_pkg(pkg) do
    Mix.shell.info """
    Pkg:      #{pkg.app}
    Vsn:      #{pkg.version}
    Type:     #{pkg.type}
    Provider: #{inspect pkg.provider}
    """
  end

end
