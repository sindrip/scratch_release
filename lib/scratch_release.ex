defmodule ScratchRelease do
  @moduledoc """
  Documentation for `ScratchRelease`.
  """

  @core_tools [
    "sh",
    "readlink",
    "dirname",
    "cut",
    "sed",
    "cat",
    "grep",
    "basename",
    "od",
    "awk"
  ]

  @doc """
  This step can be placed anywhere in the release steps, but ideally should be placed at the end.

  It appends `&move_release_files/1` and `&assemble/1` to the release steps.

  example: [
    include_executables_for: [:unix],
    steps: [:assemble, &ScratchRelease.release/1]
  ]
  """
  @spec release(Mix.Release.t()) :: Mix.Release.t()
  def release(%Mix.Release{steps: steps} = release) do
    %Mix.Release{release | steps: steps ++ [&move_release_files/1, &assemble/1]}
  end

  @doc """
  This step should be put after `:assemble` in the release steps.

  It moves all the release files into a new directory with the name of the release.
  """
  @spec move_release_files(Mix.Release.t()) :: Mix.Release.t()
  def move_release_files(%Mix.Release{name: name, path: path} = release) do
    app_name = Atom.to_string(name)

    files_to_move =
      File.ls!(path)
      |> Enum.filter(&(&1 != app_name))

    new_app_path = Path.join(path, app_name)

    File.mkdir(new_app_path)

    for f <- files_to_move do
      file_path = Path.join(path, f)
      new_file_path = Path.join(new_app_path, f)

      File.cp_r!(file_path, new_file_path, on_conflict: fn _, _ -> false end)
      File.rm_rf!(file_path)
    end

    release
  end

  @doc """
  This step should be put after `/move_release_files/1` in the release steps.

  It copies all required binaries and dynamic libraries to the root of the release.

  example: [
    include_executables_for: [:unix],
    steps: [:assemble, &ScratchRelease.move_release_files/1, &ScratchRelease.assemble/1]
  ]
  """
  @spec assemble(Mix.Release.t()) :: Mix.Release.t()
  def assemble(%Mix.Release{path: path} = release) do
    core_tools_paths = which(@core_tools)
    release_files = list_files(path)

    dynamic_libs =
      (core_tools_paths ++ release_files)
      |> Enum.flat_map(&dynamic_libraries/1)
      |> Enum.uniq()

    (core_tools_paths ++ dynamic_libs)
    |> Enum.each(&copy_to_release(release, &1))

    release
  end

  defp which(binaries) do
    {output, 0} = System.cmd("which", binaries)

    String.split(output)
    |> Enum.map(&String.trim/1)
  end

  defp list_files(path) do
    if File.dir?(path) do
      File.ls!(path)
      |> Enum.map(&Path.join(path, &1))
      |> Enum.flat_map(&list_files/1)
    else
      [path]
    end
  end

  defp copy_to_release(%Mix.Release{path: path}, file) do
    new_path = Path.join(path, file)
    new_dir = Path.dirname(new_path)
    :ok = File.mkdir_p(new_dir)
    :ok = File.cp(file, new_path)
  end

  defp dynamic_libraries(file) do
    case System.cmd("ldd", [file], stderr_to_stdout: true) do
      {output, 0} ->
        String.split(output, "\n")
        |> Enum.map(&parse_ldd/1)
        |> Enum.filter(&is_binary/1)

      {_output, _exit_code} ->
        []
    end
  end

  defp parse_ldd(nil), do: nil

  defp parse_ldd(line) do
    lib = String.split(line)

    case lib do
      [_, "=>", absolute_path, _] ->
        absolute_path

      [absolute_path, _] ->
        if String.contains?(absolute_path, "ld-linux") do
          absolute_path
        else
          nil
        end

      _ ->
        nil
    end
  end
end
