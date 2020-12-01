defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Prog.hello()
      :world

  """
  def solve do
    {:ok, raw} = File.read("input")
    strings = String.split(raw, "\n")
    as_ints = Enum.map(strings, fn(s) -> String.to_integer(s) end)
    sorted = Enum.sort(as_ints)
    head = List.first(sorted)
    tail = List.last(sorted)
    rem = List.delete_at(sorted, 0) |> List.delete_at(-1)
    part_1_res = find_it(2020, head, tail, rem)
    IO.puts part_1_res

    part_2_res = find_it(2020, sorted)
    IO.puts part_2_res
    :world
  end

  # O(n log(n))
  # Part 1
  def find_it(target, head, tail, rem) do
    # 1000, 2000
    cond do
      head + tail == target ->
        head * tail
      head + tail > target ->
        next_tail = List.last(rem)
        updated_rem = List.delete_at(rem, -1)
        find_it(target, head, next_tail, updated_rem)
      head + tail < target ->
        next_head = List.first(rem)
        updated_rem = List.delete_at(rem, 0)
        find_it(target, next_head, tail, updated_rem)
    end
  end

  # O(n^2 log(n))
  # Part 2
  def find_it(target, rem) do
    res = rem
    |> Enum.with_index
    |> Enum.map(fn({invariant, i}) ->
      current_rem = List.delete_at(rem, i)
      head = List.first(current_rem)
      tail = List.last(current_rem)
      current_rem_go = List.delete_at(current_rem, 0) |> List.delete_at(-1)
      find_it_iter(target, head, tail, invariant, current_rem_go)
    end)
    IO.puts res
  end

  def find_it_iter(target, head, tail, invariant, rem) do
    cond do
      head == nil || tail == nil ->
        0
      head + tail + invariant == target ->
        head * tail * invariant
      head + tail + invariant > target ->
        next_tail = List.last(rem)
        updated_rem = List.delete_at(rem, -1)
        find_it_iter(target, head, next_tail, invariant, updated_rem)
      head + tail + invariant < target ->
        next_head = List.first(rem)
        updated_rem = List.delete_at(rem, 0)
        find_it_iter(target, next_head, tail, invariant, updated_rem)
    end
  end
end

Prog.solve
