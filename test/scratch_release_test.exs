defmodule ScratchReleaseTest do
  use ExUnit.Case
  doctest ScratchRelease

  test "greets the world" do
    assert ScratchRelease.hello() == :world
  end
end
