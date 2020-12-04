defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 4
  """

  def solve do
    {:ok, raw} = File.read("data/day_4")
    final = String.split(raw, "\n\n")
              |> Enum.map(&extract/1)
              |> Enum.map(&validate/1)
    count = Enum.reduce(final, 0, fn valid, acc -> if valid, do: acc + 1, else: acc end)

    IO.inspect count
  end

  def extract(passport) do
    split = String.split(passport, "\n")
    haha = Enum.flat_map(split, fn blah -> String.split(blah, " ") end)
    Enum.reduce(haha, %{}, fn kv, entry ->
      [k, v] = String.split(kv, ":")
      Map.put(entry, k, v)
    end)
  end

  def validate(passport) do
    required = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    req = MapSet.new(required)
    keys = MapSet.new(Map.keys(passport))
    MapSet.subset?(req, keys)
  end
end

Prog.solve
