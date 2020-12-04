defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 4
  """

  def solve do
    {:ok, raw} = File.read("data/day_4")
    final = String.split(raw, "\n\n")
              |> Enum.map(&extract/1)
              |> Enum.map(&validate/1)
    count = Enum.reduce(final, 0, fn valid, acc -> if valid, do: acc + 1, else: acc end)

    IO.inspect count
  end

  def extract(passport) do
    String.split(passport, "\n")
      |> Enum.flat_map(fn line -> String.split(line, " ") end)
      |> Enum.reduce(%{}, fn kv, entry ->
        [k, v] = String.split(kv, ":")
        Map.put(entry, k, v)
      end)
  end

  def validate(passport) do
    required = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    req = MapSet.new(required)
    keys = MapSet.new(Map.keys(passport))
    if MapSet.subset?(req, keys) do
      validators = [
        {"byr", &birthyear_match/1},
        {"iyr", &issueyear_match/1},
        {"eyr", &expirationyear_match/1},
        {"hgt", &height_match/1},
        {"hcl", &hair_color_match/1},
        {"ecl", &eye_color_match/1},
        {"pid", &passport_id_match/1}]
      Enum.all?(validators, fn {k, f} -> f.(Map.get(passport, k, nil)) end)
    else
      false
    end
  end

  def birthyear_match(byr) do
    b = String.to_integer(byr)
    b >= 1920 && b <= 2002
  end

  def issueyear_match(iyr) do
    i = String.to_integer(iyr)
    i >= 2010 && i <= 2020
  end

  def expirationyear_match(eyr) do
    e = String.to_integer(eyr)
    e >= 2020 && e <= 2030
  end

  def height_match(hgt) do
    inches_or_cm = Regex.named_captures(~r/((?<cm>\d+)cm|(?<in>\d+)in)/, hgt)
    case inches_or_cm do
      %{"cm" => height, "in" => ""} ->
        h = String.to_integer(height)
        h >= 150 && h <= 193
      %{"in" => height, "cm" => ""} ->
        h = String.to_integer(height)
        h >= 59 && h <= 76
      _ ->
        false
    end
  end

  def hair_color_match(hcl) do
    Regex.match?(~r/^#([0-9a-f]){6}$/, hcl)
  end

  def eye_color_match(ecl) do
    Regex.match?(~r/(amb|blu|brn|gry|grn|hzl|oth)/, ecl)
  end

  def passport_id_match(pid) do
    Regex.match?(~r/^[0-9]{9}$/, pid)
  end
end

Prog.solve
