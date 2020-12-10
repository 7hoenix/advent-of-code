defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 9
  """

  def solve do
    {:ok, raw} = File.read("data/day_9")
    # raw = "35
# 20
# 15
# 25
# 47
# 40
# 62
# 55
# 65
# 95
# 102
# 117
# 150
# 182
# 127
# 219
# 299
# 277
# 309
# 576"
    final = String.split(raw, "\n", trim: true)
            |> Enum.map(&String.to_integer/1)
    num_that_isnt = find_non_xmas_number(25, [], final)
    IO.inspect num_that_isnt, label: "Num that isn't ------"
  end

  defp find_non_xmas_number(previous_to_consider, queue, []), do: 0

  defp find_non_xmas_number(previous_to_consider, queue, [nxt | rem]) do
    cond do
      length(queue) > previous_to_consider ->
        raise "Queue is growing!"
      length(queue) == previous_to_consider ->
        all_possible = MapSet.new(perms(queue))
        if MapSet.member?(all_possible, nxt) do
          [ h | updated_queue ] = queue
          updated_queue = updated_queue ++ [nxt]
          find_non_xmas_number(previous_to_consider, updated_queue, rem)
        else
          nxt
        end
      length(queue) < previous_to_consider ->
        updated_queue = queue ++ [nxt]
        find_non_xmas_number(previous_to_consider, updated_queue, rem)
    end
  end

  def perms(list) do
    for h <- list, t <- (list -- [h]) do
      h + t
    end
  end
end

Prog.solve
