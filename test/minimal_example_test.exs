defmodule MinimalExampleTest do
  use ExUnit.Case

  setup_all do
    project_path =
      File.cwd!()
      |> Path.join(["/examples/minimal"])

    %{project_path: project_path}
  end

  test "hello", %{project_path: path} do
    System.shell("docker", ["build", path])
    IO.inspect(path)
    true
  end
end
