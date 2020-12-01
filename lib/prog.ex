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
    res = find_it(2020, head, tail, rem)
    IO.puts res
    :world
  end

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
end

Prog.solve
