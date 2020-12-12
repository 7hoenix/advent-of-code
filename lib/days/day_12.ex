defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 12
  """

  def solve do
    {:ok, raw} = File.read("data/day_12")
    # raw = "F10
# N3
# F7
# R90
# F11"

    data = String.split(raw, "\n", trim: true)
            |> Enum.map(&extract/1)
    distance_to_end = find_path_to_ending_location(data, {0, 0}, :east)
    {y, x} = distance_to_end
    part_1 = Kernel.abs(y) + Kernel.abs(x)
    IO.inspect part_1, label: "Part 1"
  end

  def find_path_to_ending_location([], {y, x}, _direction), do: {y, x}

  def find_path_to_ending_location([instruction | remaining], {y, x}, direction) do
    case instruction do
      %{cardinal: %{north: amount}} ->
        find_path_to_ending_location(remaining, move(:north, {y, x}, amount), direction)
      %{cardinal: %{east: amount}} ->
        find_path_to_ending_location(remaining, move(:east, {y, x}, amount), direction)
      %{cardinal: %{south: amount}} ->
        find_path_to_ending_location(remaining, move(:south, {y, x}, amount), direction)
      %{cardinal: %{west: amount}} ->
        find_path_to_ending_location(remaining, move(:west, {y, x}, amount), direction)
      %{scalar: amount} ->
        find_path_to_ending_location(remaining, move(direction, {y, x}, amount), direction)
      %{turn: %{right: amount}} ->
        turns = div(amount, 90)
        starting = find_starting(direction)
        after_turning = starting + (turns * 90)
        new_direction = find_after(rem(after_turning, 360))
        find_path_to_ending_location(remaining, {y, x}, new_direction)
      %{turn: %{left: amount}} ->
        turns = div(amount, 90)
        starting = find_starting(direction)
        after_turning = (360 + starting) - (turns * 90)
        new_direction = find_after(rem(after_turning, 360))
        find_path_to_ending_location(remaining, {y, x}, new_direction)
    end
  end

  def move(:north, {y, x}, amount), do: {y + amount, x}
  def move(:east, {y, x}, amount), do: {y, x + amount}
  def move(:south, {y, x}, amount), do: {y - amount, x}
  def move(:west, {y, x}, amount), do: {y, x - amount}

  def find_starting(:north), do: 0
  def find_starting(:east), do: 90
  def find_starting(:south), do: 180
  def find_starting(:west), do: 270

  def find_after(0), do: :north
  def find_after(90), do: :east
  def find_after(180), do: :south
  def find_after(270), do: :west

  def extract(row) do
    [action | amount] = String.split(row, "", trim: true)
    amount = Enum.join(amount, "")
             |> String.to_integer()
    case action do
      "N" ->
        %{cardinal: %{north: amount}}
      "E" ->
        %{cardinal: %{east: amount}}
      "S" ->
        %{cardinal: %{south: amount}}
      "W" ->
        %{cardinal: %{west: amount}}
      "F" ->
        %{scalar: amount}
      "R" ->
        %{turn: %{right: amount}}
      "L" ->
        %{turn: %{left: amount}}
    end
  end
end

Prog.solve
