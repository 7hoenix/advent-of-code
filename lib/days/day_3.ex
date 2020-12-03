defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 3
  """

  def solve do
    {:ok, raw} = File.read("data/day_3")
    trimmed = String.split(raw, "\n")
              |> Enum.map(&String.trim/1)
    world = Stream.repeatedly(fn() -> trimmed end)
            |> Stream.take(100)
            |> Stream.zip()
            |> Enum.to_list()
            |> Enum.map(fn(row) -> Enum.join(Tuple.to_list(row)) end)
    # part_1_ratio = [
    #   %{dx: 3, dy: 1},
    # ]
    part_2_ratios = [
      %{dx: 3, dy: 1},
      %{dx: 1, dy: 1},
      %{dx: 5, dy: 1},
      %{dx: 7, dy: 1},
      %{dx: 1, dy: 2},
    ]
    trees_hit = Enum.map(part_2_ratios, fn(ratio) -> traverse_with(world, %{x: 0, y: 0}, 0, ratio) end)
    IO.inspect trees_hit
    trees_hit_multiplied = Enum.reduce(trees_hit, fn(cur, acc) -> cur * acc end)
    IO.inspect trees_hit_multiplied
  end

  def traverse_with(world, %{x: x, y: y} = coords, trees_hit, %{dx: dx, dy: dy} = ratio) do
    value_at_coordinates = at_coords(world, coords)
    trees_hit_count = cond do
      value_at_coordinates == "#" ->
        trees_hit + 1
      value_at_coordinates == "." ->
        trees_hit + 0
    end
    cond do
      y == 322 ->
        trees_hit_count
      true ->
        traverse_with(world, %{x: x + dx, y: y + dy}, trees_hit_count, ratio)
    end
  end

  def at_coords(world, %{x: x, y: y}) do
    Enum.at(world, y)
    |> String.at(x)
  end
end

Prog.solve
