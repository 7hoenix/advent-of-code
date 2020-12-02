defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 2
  """

  def solve do
    {:ok, raw} = File.read("data/day_2/input")
    res = String.split(raw, "\n")
      |> Enum.map(&parse_password_with_policy/1)
      |> Enum.reduce(0, &validate_passwords_by_policy/2)
    IO.puts res
  end

  def parse_password_with_policy(raw) do
    [policy, password] = String.split(raw, ":")
    [range, required_char] = String.split(policy, " ")
    [min_required, max_allowed] = String.split(range, "-")
    %{min_required: String.to_integer(min_required),
      max_allowed: String.to_integer(max_allowed),
      required_char: required_char,
      password: String.trim(password)}
  end

  def validate_passwords_by_policy(%{ min_required: min_required, max_allowed: max_allowed, required_char: req, password: password } = foo, current_count) do
    letters_with_counts = Enum.reduce(String.split(password, "", trim: true), Map.new(), &populate_count/2)
    # IO.puts "----------------"
    # IO.inspect letters_with_counts
    # IO.inspect foo
    if max_allowed >= Map.get(letters_with_counts, req) and Map.get(letters_with_counts, req) >= min_required do
      # IO.puts "valid"
      current_count + 1
    else
      # IO.puts "invalid"
      current_count
    end
  end

  def populate_count(letter, letters_with_counts) do
    Map.update(letters_with_counts, letter, 1, fn(count) -> count + 1 end)
  end
end

Prog.solve
