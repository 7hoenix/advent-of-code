defmodule Prog do
  @moduledoc """
  Documentation for `Prog`.
  """

  @doc """
  Day 8
  """

  def solve do
    {:ok, raw} = File.read("data/day_8")
    # raw="nop +0
# acc +1
# jmp +4
# acc +3
# jmp -3
# acc -99
# acc +1
# jmp -4
# acc +6"
    final = String.split(raw, "\n", trim: true)
            |> Enum.map(&extract/1)
    acc_at_first_loop = find_loop(final, 0, MapSet.new(), 0, -1)
    IO.inspect acc_at_first_loop

    acc_after_fix = find_fix(final, 0)
    IO.inspect acc_after_fix

  end

  def extract(instruction) do
    [ins, plus_or_minus_num] = String.split(instruction, " ", trim: true)
    {sign, val} = extract_value(plus_or_minus_num)
    case ins do
      "nop" ->
        {:nop, sign, val}
      "acc" ->
        {:acc, sign, val}
      "jmp" ->
        {:jmp, sign, val}
    end
  end

  def extract_value(plus_or_minus_num) do
    {plus_or_minus, num} = String.split_at(plus_or_minus_num, 1)
    n = String.to_integer(num)

    case plus_or_minus do
      "+" ->
        {:add, n}
      "-" ->
        {:subtract, n}
      true ->
        raise "Not supported"
    end
  end

  def find_fix(instructions, attempting_to_change) do
    final_length = length(instructions) - 1
    with_i = Enum.with_index(instructions)
    updated_instructions = Enum.map(with_i, fn {ins, i} ->
                             case {i == attempting_to_change, ins} do
                               {false, _} ->
                                 ins
                               {true, {:acc, _, _}} ->
                                 ins
                               {true, {:jmp, s, v}} ->
                                 {:nop, s, v}
                               {true, {:nop, s, v}} ->
                                 {:jmp, s, v}
                             end
                           end)

    case find_loop(updated_instructions, 0, MapSet.new(), 0, final_length) do
      {:solved, acc} ->
        acc
      _acc ->
        find_fix(instructions, attempting_to_change + 1)
    end
  end

  def find_loop(instructions, executing, execution_context, acc, last_instruction) do
    case Enum.at(instructions, executing) do
      {:nop, _sign, _val} ->
        if MapSet.member?(execution_context, executing + 1) do
            acc
        else
            find_loop(instructions, executing + 1, MapSet.put(execution_context, executing + 1), acc, last_instruction)
        end
      {:acc, sign, val} ->
        if MapSet.member?(execution_context, executing + 1) do
            acc
        else
            updated_acc = resolve_sign(sign, acc, val)
            find_loop(instructions, executing + 1, MapSet.put(execution_context, executing + 1), updated_acc, last_instruction)
        end
      {:jmp, sign, val} ->
        updated_executing = resolve_sign(sign, executing, val)
        if MapSet.member?(execution_context, updated_executing) do
            acc
        else
            find_loop(instructions, updated_executing, MapSet.put(execution_context, updated_executing), acc, last_instruction)
        end
      nil ->
        {:solved, acc}
    end
  end

  def resolve_sign(sign, val1, val2) do
    case sign do
      :add ->
        val1 + val2
      :subtract ->
        val1 - val2
    end
  end
end

Prog.solve
