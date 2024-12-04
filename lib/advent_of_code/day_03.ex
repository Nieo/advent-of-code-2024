defmodule AdventOfCode.Day03 do
  def part1(args) do
    parser(args, {:nop}, 0, :enabled)
  end

  def part2(args) do
    parser(args, {:nop}, 0, :enabled)
  end

  def parser(<<>>, _, result, _) do
    result
  end

  def parser(<<"do()", rest::binary>>, _, result, _) do
    parser(rest, {:nop}, result, :enabled)
  end

  def parser(<<"don't()", rest::binary>>, _, result, _) do
    parser(rest, {:nop}, result, :disabled)
  end

  def parser(<<"mul(", rest::binary>>, _, result, state) do
    parser(rest, {:mul, []}, result, state)
  end

  def parser(<<")", rest::binary>>, {:mul, x, y}, result, :enabled) when x != [] and y != [] do
    parser(
      rest,
      {:nop},
      List.to_integer(Enum.reverse(x)) * List.to_integer(Enum.reverse(y)) + result,
      :enabled
    )
  end

  def parser(<<",", rest::binary>>, {:mul, b1}, result, state) when b1 != [] do
    parser(rest, {:mul, b1, []}, result, state)
  end

  def parser(<<char, rest::binary>>, {:mul, b1}, result, state) do
    if char >= 48 and char <= 57 do
      parser(rest, {:mul, [char | b1]}, result, state)
    else
      parser(rest, {:nop}, result, state)
    end
  end

  def parser(<<char, rest::binary>>, {:mul, b1, b2}, result, state) do
    if char >= 48 and char <= 57 do
      parser(rest, {:mul, b1, [char | b2]}, result, state)
    else
      parser(rest, {:nop}, result, state)
    end
  end

  def parser(<<_, rest::binary>>, _, result, state) do
    parser(rest, {:nop}, result, state)
  end
end
