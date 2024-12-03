defmodule AdventOfCode.Day03 do
  def part1(args) do
    parser1(args, {:nop}, 0)
  end

  def parser1(<<>>, _, result) do
    result
  end

  def parser1(<<"mul(", rest::binary>>, _, result) do
    parser1(rest, {:mul, []}, result)
  end

  def parser1(<<")", rest::binary>>, {:mul, x, y}, result) when x != [] and y != [] do
    parser1(
      rest,
      {:nop},
      List.to_integer(Enum.reverse(x)) * List.to_integer(Enum.reverse(y)) + result
    )
  end

  def parser1(<<",", rest::binary>>, {:mul, b1}, result) when b1 != [] do
    parser1(rest, {:mul, b1, []}, result)
  end

  def parser1(<<char, rest::binary>>, {:mul, b1}, result) do
    if char >= 48 and char <= 57 do
      parser1(rest, {:mul, [char | b1]}, result)
    else
      parser1(rest, {:nop}, result)
    end
  end

  def parser1(<<char, rest::binary>>, {:mul, b1, b2}, result) do
    if char >= 48 and char <= 57 do
      parser1(rest, {:mul, b1, [char | b2]}, result)
    else
      parser1(rest, {:nop}, result)
    end
  end

  def parser1(<<_, rest::binary>>, _, result) do
    parser1(rest, {:nop}, result)
  end

  def part2(_args) do
  end
end
