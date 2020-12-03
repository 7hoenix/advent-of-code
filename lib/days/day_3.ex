defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 3
  """

  def solve do
    {:ok, raw} = File.read("data/day_3")
    res = String.split(raw, "\n")
    trimmed = Enum.map(res, &String.trim/1)
    slices = Stream.repeatedly(fn() -> trimmed end) |> Stream.take(100)
    final = Stream.zip(slices) |> Enum.to_list()
    final_final = Enum.map(final, fn(row) -> Enum.join(Tuple.to_list(row)) end)
    trees_hit = traverse_with(final_final, %{x: 0, y: 0}, 0)
    IO.inspect trees_hit
  end

  def traverse_with(world, %{x: x, y: y} = coords, trees_hit) do
    value_on_world = at_coords(world, coords)
    cond do
      y == 322 ->
        cond do
          value_on_world == "#" ->
            trees_hit + 1
          value_on_world == "." ->
            trees_hit + 0
        end
      true ->
        cond do
          value_on_world == "#" ->
            traverse_with(world, %{x: x + 3, y: y + 1}, trees_hit + 1)
          value_on_world == "." ->
            traverse_with(world, %{x: x + 3, y: y + 1}, trees_hit + 0)
        end
    end
  end

  def at_coords(world, %{x: x, y: y}) do
    Enum.at(world, y)
    |> String.at(x)
  end

end

Prog.solve
