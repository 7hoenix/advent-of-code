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
    p = String.split(password, "", trim: true)
    value_at_min_index = Enum.at(p, min_required - 1)
    value_at_max_index = Enum.at(p, max_allowed - 1)

    cond do
      value_at_min_index == value_at_max_index and value_at_min_index == req ->
        current_count
      value_at_max_index == req or value_at_min_index == req ->
        current_count + 1
      true ->
        current_count
    end
  end
end

Prog.solve
