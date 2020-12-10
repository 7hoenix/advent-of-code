defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 10
  """

  def solve do
    {:ok, raw} = File.read("data/day_10")
    # raw = "28
# 33
# 18
# 42
# 31
# 14
# 46
# 20
# 48
# 47
# 24
# 23
# 49
# 45
# 19
# 38
# 39
# 11
# 1
# 32
# 25
# 35
# 8
# 17
# 7
# 9
# 4
# 2
# 34
# 10
# 3"
    final = String.split(raw, "\n", trim: true)
            |> Enum.map(&String.to_integer/1)
    distribution = %{one: 0, two: 0, three: 0}
    final_distribution = find_adapter_distribution(Enum.sort(final), 0, distribution)
    IO.inspect final_distribution, label: "Part 1 distribution"
    part_one_answer = Map.fetch!(final_distribution, :one) * Map.fetch!(final_distribution, :three)
    IO.inspect part_one_answer, label: "Part 1"
  end

  def find_adapter_distribution([], previous_joltage, distribution), do: Map.update!(distribution, :three, &(&1 + 1))

  def find_adapter_distribution([nxt | rem], previous_joltage, distribution) do
    case nxt - previous_joltage do
      1 ->
        find_adapter_distribution(rem, nxt, Map.update!(distribution, :one, &(&1 + 1)))
      2 ->
        find_adapter_distribution(rem, nxt, Map.update!(distribution, :two, &(&1 + 1)))
      3 ->
        find_adapter_distribution(rem, nxt, Map.update!(distribution, :three, &(&1 + 1)))
      true ->
        raise "No chain possible"
    end
  end
end

Prog.solve
