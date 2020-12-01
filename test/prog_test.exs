defmodule ProgTest do
  use ExUnit.Case
  doctest Prog

  test "greets the world" do
    assert Prog.hello() == :world
  end
end
