defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 7
  """

  def solve do
    {:ok, raw} = File.read("data/day_7")
    # raw = "shiny gold bags contain 2 dark red bags.
# dark red bags contain 2 dark orange bags.
# dark orange bags contain 2 dark yellow bags.
# dark yellow bags contain 2 dark green bags.
# dark green bags contain 2 dark blue bags.
# dark blue bags contain 2 dark violet bags.
# dark violet bags contain no other bags.
# "
    final = String.split(raw, "\n", trim: true)
            |> Enum.reduce(Map.new(), fn bag, acc ->
              {b, bs} = extract(bag)
              Map.put(acc, b, bs)
            end)
    IO.inspect final
    part_two = find_contains_count(final, "shiny gold")
    IO.inspect part_two

    please = Enum.map(final, fn {bag, c} -> can_contain(bag, final, "shiny gold") end)
    count = Enum.reduce(please, 0, fn entry, acc -> if entry, do: 1 + acc, else: acc end)
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

  def find_contains_count(memo, query) do
    current = Map.get(memo, query)

    IO.inspect current
    cond do
      current == %{"other" => "no"} ->
        0
      true ->
        Enum.reduce(current, 0, fn {k, v}, acc ->
          cur = acc + (find_contains_count(memo, k) * String.to_integer(v)) + String.to_integer(v)
          cur
        end)
    end
  end
end

Prog.solve
