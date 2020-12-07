defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 6
  """

  def solve do
    {:ok, raw} = File.read("data/day_6")
    final = String.split(raw, "\n\n", trim: true)
              |> Enum.map(&extract/1)
    count = Enum.reduce(final, 0, fn group, acc -> MapSet.size(group) + acc end)
    IO.inspect count
  end

  def extract(group) do
    thing = String.split(group, "\n", trim: true)
    all_in_group = Enum.flat_map(thing, fn line -> String.split(line, "", trim: true) end)
    MapSet.new(all_in_group)
  end
end

Prog.solve
