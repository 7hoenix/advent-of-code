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
    nums = encryption_weakness(num_that_isnt, [], final)
    IO.inspect nums, label: "Part 2"
    srted = Enum.sort(nums)
    [h | rem ] = srted
    lst = List.last(rem)
    IO.inspect h + lst, label: "Part 2 answer"
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

  defp encryption_weakness(search_query, [], [nxt | rem]), do: encryption_weakness(search_query, [nxt], rem)

  defp encryption_weakness(search_query, queue, [nxt | rem]) do
    if Enum.sum(queue ++ [nxt]) > search_query do
      [h | rst] = queue
      without_previous = rst ++ [nxt]
      case check_contiguous(search_query, without_previous) do
        [] ->
          encryption_weakness(search_query, rst ++ [nxt], rem)
        set_found ->
          set_found
      end
    else
      case check_contiguous(search_query, queue ++ [nxt]) do
        [] ->
          encryption_weakness(search_query, queue ++ [nxt], rem)
        set_found ->
          set_found
      end
    end
  end

  def check_contiguous(search_query, queue) do
    from_front = check_contiguous_inner(search_query, queue)
    from_back = check_contiguous_inner(search_query, Enum.reverse(queue))
    case {from_front, from_back} do
      {[], []} ->
        []
      {found, []} ->
        found
      {[], found} ->
        found
      {found, found} ->
        found
      {a, b} ->
        IO.inspect a
        IO.inspect b
        raise "two possible??"
    end
  end

  def check_contiguous_inner(search_query, []), do: []

  def check_contiguous_inner(search_query, [h | rem]) do
    if Enum.sum(rem) == search_query do
      rem
    else
      check_contiguous_inner(search_query, rem)
    end
  end

  def perms(list) do
    for h <- list, t <- (list -- [h]) do
      h + t
    end
  end
end

Prog.solve
