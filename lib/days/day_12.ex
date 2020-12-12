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

    actual_distance_to_end = find_path_to_ending_location_waypoints(data, {0, 0}, {{:east, 10}, {:north, 1}})
    {actual_y, actual_x} = actual_distance_to_end
    part_2 = Kernel.abs(actual_y) + Kernel.abs(actual_x)
    IO.inspect part_2, label: "Part 2"
  end

  def find_path_to_ending_location([], {y, x}, _direction), do: {y, x}

  def find_path_to_ending_location([instruction | remaining], {y, x}, direction) do
    case instruction do
      %{cardinal: {dir, amount}} ->
        find_path_to_ending_location(remaining, move(dir, {y, x}, amount), direction)
      %{scalar: amount} ->
        find_path_to_ending_location(remaining, move(direction, {y, x}, amount), direction)
      %{turn: {:right, amount}} ->
        turns = div(amount, 90)
        starting = find_starting(direction)
        after_turning = starting + (turns * 90)
        new_direction = find_after(rem(after_turning, 360))
        find_path_to_ending_location(remaining, {y, x}, new_direction)
      %{turn: {:left, amount}} ->
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

  def find_path_to_ending_location_waypoints([], {y, x}, _waypoint), do: {y, x}

  def find_path_to_ending_location_waypoints([instruction | remaining], {y, x}, {{horizontal, horizontal_amount}, {vertical, vertical_amount}} = waypoint ) do
    case instruction do
      %{cardinal: {:north, amount}} ->
        updated_vertical = handle_waypoint_update({vertical, vertical_amount}, {:north, amount})
        find_path_to_ending_location_waypoints(remaining, {y, x}, {{horizontal, horizontal_amount}, updated_vertical})
      %{cardinal: {:east, amount}} ->
        updated_horizontal = handle_waypoint_update({horizontal, horizontal_amount}, {:east, amount})
        find_path_to_ending_location_waypoints(remaining, {y, x}, {updated_horizontal, {vertical, vertical_amount}})
      %{cardinal: {:south, amount}} ->
        updated_vertical = handle_waypoint_update({vertical, vertical_amount}, {:south, amount})
        find_path_to_ending_location_waypoints(remaining, {y, x}, {{horizontal, horizontal_amount}, updated_vertical})
      %{cardinal: {:west, amount}} ->
        updated_horizontal = handle_waypoint_update({horizontal, horizontal_amount}, {:west, amount})
        find_path_to_ending_location_waypoints(remaining, {y, x}, {updated_horizontal, {vertical, vertical_amount}})
      %{scalar: amount} ->
        updated_y = if vertical == :north do
          y + (vertical_amount * amount)
        else
          y - (vertical_amount * amount)
        end
        updated_x = if horizontal == :east do
          x + (horizontal_amount * amount)
        else
          x - (horizontal_amount * amount)
        end
        find_path_to_ending_location_waypoints(remaining, {updated_y, updated_x}, waypoint)
      %{turn: {:right, amount}} ->
        turns = div(amount, 90)
        updated_waypoint = rotate_right(turns, waypoint)
        find_path_to_ending_location_waypoints(remaining, {y, x}, updated_waypoint)
      %{turn: {:left, amount}} ->
        turns = div(amount, 90)
        updated_waypoint = rotate_left(turns, waypoint)
        find_path_to_ending_location_waypoints(remaining, {y, x}, updated_waypoint)
    end
  end

  def rotate_right(0, waypoint), do: waypoint
  def rotate_right(turns, {{:east, horizontal_amount}, {:north, vertical_amount}}), do: rotate_right(turns - 1, {{:east, vertical_amount}, {:south, horizontal_amount}})
  def rotate_right(turns, {{:east, horizontal_amount}, {:south, vertical_amount}}), do: rotate_right(turns - 1, {{:west, vertical_amount}, {:south, horizontal_amount}})
  def rotate_right(turns, {{:west, horizontal_amount}, {:south, vertical_amount}}), do: rotate_right(turns - 1, {{:west, vertical_amount}, {:north, horizontal_amount}})
  def rotate_right(turns, {{:west, horizontal_amount}, {:north, vertical_amount}}), do: rotate_right(turns - 1, {{:east, vertical_amount}, {:north, horizontal_amount}})

  def rotate_left(0, waypoint), do: waypoint
  def rotate_left(turns, {{:east, horizontal_amount}, {:north, vertical_amount}}), do: rotate_left(turns - 1, {{:west, vertical_amount}, {:north, horizontal_amount}})
  def rotate_left(turns, {{:west, horizontal_amount}, {:north, vertical_amount}}), do: rotate_left(turns - 1, {{:west, vertical_amount}, {:south, horizontal_amount}})
  def rotate_left(turns, {{:west, horizontal_amount}, {:south, vertical_amount}}), do: rotate_left(turns - 1, {{:east, vertical_amount}, {:south, horizontal_amount}})
  def rotate_left(turns, {{:east, horizontal_amount}, {:south, vertical_amount}}), do: rotate_left(turns - 1, {{:east, vertical_amount}, {:north, horizontal_amount}})

  def handle_waypoint_update({current_direction, current_amount}, {current_direction, update_amount}), do: {current_direction, current_amount + update_amount}

  def handle_waypoint_update({current_direction, current_amount}, {reverse_direction, update_amount}) do
    if current_amount - update_amount < 0 do
      {reverse_direction, update_amount - current_amount}
    else
      {current_direction, current_amount - update_amount}
    end
  end

  def extract(row) do
    [action | amount] = String.split(row, "", trim: true)
    amount = Enum.join(amount, "")
             |> String.to_integer()
    case action do
      "N" ->
        %{cardinal: {:north, amount}}
      "E" ->
        %{cardinal: {:east, amount}}
      "S" ->
        %{cardinal: {:south, amount}}
      "W" ->
        %{cardinal: {:west, amount}}
      "F" ->
        %{scalar: amount}
      "R" ->
        %{turn: {:right, amount}}
      "L" ->
        %{turn: {:left, amount}}
    end
  end
end

Prog.solve
