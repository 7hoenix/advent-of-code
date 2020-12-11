defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 11
  """

  def solve do
    {:ok, raw} = File.read("data/day_11")
    # raw = "L.LL.LL.LL
# LLLLLLL.LL
# L.L.L..L..
# LLLL.LL.LL
# L.LL.LL.LL
# L.LLLLL.LL
# ..L.L.....
# LLLLLLLLLL
# L.LLLLLL.L
# L.LLLLL.LL"

    data = String.split(raw, "\n", trim: true)
            |> Enum.map(&extract/1)
    column_size = length(List.first(data)) - 1
    row_size = length(data) - 1
    as_map = convert_to_map(data)
             |> Enum.reduce(Map.new(), fn row, acc ->
                Enum.reduce(row, acc, &put_stuff/2) end)

    part_1 = find_occupied_seats_after_stabalizing(as_map, row_size, column_size, &occupied_adjacent_seats/3, 4)
    IO.inspect part_1, label: "Part 1"

    part_2 = find_occupied_seats_after_stabalizing(as_map, row_size, column_size, &occupied_adjacent_seats_line_of_sight/3, 5)
    IO.inspect part_2, label: "Part 2"
  end

  def find_occupied_seats_after_stabalizing(as_map, row_size, column_size, finder, adjecent_count) do
    updates = apply_rules(as_map, row_size, column_size, finder, adjecent_count)
              |> Enum.reject(&is_nil/1)
    updated_map = Enum.reduce(updates, as_map, fn {coords, entry}, acc -> Map.put(acc, coords, entry) end)
    if updated_map == as_map do
      # print_waiting_room(updated_map, row_size, column_size)
      count_occupied_seats(updated_map, row_size, column_size)
    else
      find_occupied_seats_after_stabalizing(updated_map, row_size, column_size, finder, adjecent_count)
    end
  end

  def put_stuff({coords, entry}, acc) do
    Map.put(acc, coords, entry)
  end

  def convert_to_map(data) do
    data
    |> Enum.with_index
    |> Enum.map(fn {row, y} ->
      row
      |> Enum.with_index
      |> Enum.map(fn {cell, x} -> {{y,x}, cell} end)
      end)
  end

  def apply_rules(data, row_size, column_size, finder, adjecent_count) do
    Range.new(0, row_size)
    |> Enum.flat_map(fn row_index ->
      Range.new(0, column_size)
      |> Enum.map(fn column_index -> apply_rules_to_cell(row_index, column_index, data, finder, adjecent_count) end)
    end)
  end

  def apply_rules_to_cell(y, x, data, finder, adjecent_count) do
    adjacent_seats = finder.(y, x, data)
    case Map.get(data, {y,x}) do
      :empty ->
        if adjacent_seats == 0 do
          {{y, x}, :occupied}
        end
      :occupied ->
        if adjacent_seats >= adjecent_count do
          {{y, x}, :empty}
        end
      _ ->
        nil
    end
  end

  def occupied_adjacent_seats(y, x, data) do
    [
      Map.get(data, {y + 1, x - 1}),
      Map.get(data, {y + 1, x}),
      Map.get(data, {y + 1, x + 1}),

      Map.get(data, {y, x - 1}),
      Map.get(data, {y, x + 1}),

      Map.get(data, {y - 1, x - 1}),
      Map.get(data, {y - 1, x}),
      Map.get(data, {y - 1, x + 1})
    ]
    |> Enum.map(&occupied/1)
    |> Enum.sum()
  end

  def occupied_adjacent_seats_line_of_sight(y, x, data) do
    [
      occupied_seat_line_of_sight(y, fn y -> (y + 1) end, x, fn x -> (x - 1) end, data),
      occupied_seat_line_of_sight(y, fn y -> (y + 1) end, x, fn x -> x end, data),
      occupied_seat_line_of_sight(y, fn y -> (y + 1) end, x, fn x -> (x + 1) end, data),

      occupied_seat_line_of_sight(y, fn y -> y end, x, fn x -> (x - 1) end, data),
      occupied_seat_line_of_sight(y, fn y -> y end, x, fn x -> (x + 1) end, data),

      occupied_seat_line_of_sight(y, fn y -> (y - 1) end, x, fn x -> (x - 1) end, data),
      occupied_seat_line_of_sight(y, fn y -> (y - 1) end, x, fn x -> x end, data),
      occupied_seat_line_of_sight(y, fn y -> (y - 1) end, x, fn x -> (x + 1) end, data),
    ]
    |> Enum.sum()
  end

  def occupied_seat_line_of_sight(y, y_fn, x, x_fn, data) do
    next_y = y_fn.(y)
    next_x = x_fn.(x)
    case Map.get(data, {next_y, next_x}) do
      nil ->
        0
      :occupied ->
        1
      :empty ->
        0
      :floor ->
        occupied_seat_line_of_sight(next_y, y_fn, next_x, x_fn, data)
    end
  end

  def occupied(seat) do
    case seat do
      :occupied ->
        1
      _ ->
        0
    end
  end

  def extract(row) do
    String.split(row, "", trim: true)
    |> Enum.map(&extract_cell/1)
  end

  def extract_cell(cell) do
    case cell do
      "L" ->
        :empty
      "." ->
        :floor
      "#" ->
        :occupied
    end
  end

  def print_waiting_room(data, row_size, column_size) do
    IO.puts Range.new(0, row_size)
    |> Enum.map(fn row_index ->
      Range.new(0, column_size)
      |> Enum.map(fn column_index -> print_cell(Map.get(data, {row_index, column_index})) end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
  end

  def print_cell(cell) do
    case cell do
      :empty ->
        "L"
      :floor ->
        "."
      :occupied ->
        "#"
    end
  end

  def count_occupied_seats(data, row_size, column_size) do
    Range.new(0, row_size)
    |> Enum.map(fn row_index ->
      Range.new(0, column_size)
      |> Enum.map(fn column_index -> occupied(Map.get(data, {row_index, column_index})) end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end
end

Prog.solve
