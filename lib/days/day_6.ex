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
    all_in_group = String.split(group, "\n", trim: true)
    # all_in_group = Enum.flat_map(thing, fn line -> String.split(line, "", trim: true) end)
    [h | rem] = all_in_group
    all_shared_in_group = Enum.reduce(rem, s_to_map_set(h), fn line, acc -> MapSet.intersection(s_to_map_set(line), acc) end)
    MapSet.new(all_shared_in_group)
  end

  def s_to_map_set(line) do
    MapSet.new(String.split(line, "", trim: true))
  end
end

Prog.solve
