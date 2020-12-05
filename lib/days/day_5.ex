defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 5
  """

  def solve do
    {:ok, raw} = File.read("data/day_5")
    final = String.split(raw, "\n")
              |> Enum.map(&extract/1)
              |> Enum.map(&find_seat_info/1)
    sorted = Enum.sort(final)
    [h | rem] = sorted
    part_two = find_seat_part_two(rem, h)
    IO.inspect part_two

    IO.inspect List.last(sorted)
  end

  def extract(boarding_pass) do
    [row_1, row_2, row_3, row_4, row_5, row_6, row_7, seat_1, seat_2, seat_3] = String.split(boarding_pass, "", trim: true)
    {[row_1, row_2, row_3, row_4, row_5, row_6, row_7], [seat_1, seat_2, seat_3]}
  end

  def find_seat_info({row_info, seat_info}) do
    row = find_row(row_info)
    seat = find_seat(seat_info)
    row * 8 + seat
  end

  def find_row(row_info) do
    extract_decimal_from_bits(row_info, "F", 7)
  end

  def find_seat(seat_info) do
    extract_decimal_from_bits(seat_info, "L", 3)
  end

  def extract_decimal_from_bits(collection, off_symbol, number_of_bits) do
    binary = Enum.map(collection, fn x -> if x == off_symbol, do: 0, else: 1 end)
             |> Enum.into(<<>>, fn bit -> <<bit :: 1>> end)
    <<t::size(number_of_bits)>> = binary

    t
  end

  def find_seat_part_two(sorted, current) do
    [h | rem] = sorted

    if current + 1 == h do
      find_seat_part_two(rem, h)
    else
      current + 1
    end
  end
end

Prog.solve
