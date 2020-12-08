defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 7
  """

  def solve do
    {:ok, raw} = File.read("data/day_7")
    final = String.split(raw, "\n", trim: true)
            |> Enum.reduce(Map.new(), fn bag, acc ->
              {b, bs} = extract(bag)
              Map.put(acc, b, bs)
            end)
    please = Enum.map(final, fn {bag, c} -> can_contain(bag, final, "shiny gold") end)
    count = Enum.reduce(please, 0, fn entry, acc -> if entry, do: 1 + acc, else: acc end)
    IO.inspect count
  end

  def extract(rule) do
    [bag, bags_it_contains] = String.split(rule, "bags contain", trim: true)
    bags_moar = String.split(bags_it_contains, ", ", trim: true)
    bags_free = Enum.map(bags_moar, fn b -> String.trim_trailing(String.trim_trailing(String.trim_trailing(String.trim(b), "."), " bags"), " bag") end)
    bags_final = Enum.reduce(bags_free, Map.new(), fn b, acc ->
      [num | rem] = String.split(b, " ")
      Map.put(acc, Enum.join(rem, " "), num)
    end)
    {String.trim(bag), bags_final}
  end

  def can_contain(bag, memo, query) do
    current = Map.get(memo, bag)
    cond do
      current == %{"other" => "no"} ->
        false
      Map.has_key?(current, query) ->
        true
      true ->
        results = Map.get(memo, bag)
        Enum.any?(Map.keys(results), fn b -> can_contain(b, memo, query) end)
    end
  end
end

Prog.solve
