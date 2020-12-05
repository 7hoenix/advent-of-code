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
              |> Enum.map(&solve_one/1)
    # count = Enum.reduce(final, 0, fn valid, acc -> if valid, do: acc + 1, else: acc end)
    sorted = Enum.sort(final)

    IO.inspect List.last(sorted)
  end

  def solve_one(boarding_pass) do
    [extract(boarding_pass)]
    |> Enum.map(&find_seat_info/1)
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
    mapped = Enum.map(row_info, &fooer/1)
    ok = Enum.into(mapped, <<>>, fn bit -> <<bit :: 1>> end)
    <<t::size(7)>> = ok

    # IO.inspect t
    # IO.inspect ok
    t
  end

  def find_seat(seat_info) do
    mapped = Enum.map(seat_info, &barer/1)
    ok = Enum.into(mapped, <<>>, fn bit -> <<bit :: 1>> end)
    <<t::size(3)>> = ok

    # IO.inspect t
    # IO.inspect ok
    t
  end


  def fooer(id) do
      if id == "F" do
        0
      else
        1
      end
  end

  def barer(id) do
      if id == "L" do
        0
      else
        1
      end
  end
end

Prog.solve
# Prog.solve_one("BBFFBBFRLL")
