defmodule AdventOfCode.Day03 do
  def part1(args) do
    parser1(args, {:nop}, 0, :enabled)
  end

  def part2(args) do
    parser1(args, {:nop}, 0, :enabled)
  end

  def parser1(<<>>, _, result, _) do
    result
  end

  def parser1(<<"do()", rest::binary>>, _, result, _) do
    parser1(rest, {:nop}, result, :enabled)
  end


  def parser1(<<"don't()", rest::binary>>, _, result, _) do
    parser1(rest, {:nop}, result, :disabled)
  end

  def parser1(<<"mul(", rest::binary>>, _, result, state) do
    parser1(rest, {:mul, []}, result, state)
  end

  def parser1(<<")", rest::binary>>, {:mul, x, y}, result, :enabled) when x != [] and y != [] do
    parser1(
      rest,
      {:nop},
      List.to_integer(Enum.reverse(x)) * List.to_integer(Enum.reverse(y)) + result,
      :enabled
    )
  end

  def parser1(<<",", rest::binary>>, {:mul, b1}, result, state) when b1 != [] do
    parser1(rest, {:mul, b1, []}, result, state)
  end

  def parser1(<<char, rest::binary>>, {:mul, b1}, result, state) do
    if char >= 48 and char <= 57 do
      parser1(rest, {:mul, [char | b1]}, result, state)
    else
      parser1(rest, {:nop}, result, state)
    end
  end

  def parser1(<<char, rest::binary>>, {:mul, b1, b2}, result, state) do
    if char >= 48 and char <= 57 do
      parser1(rest, {:mul, b1, [char | b2]}, result, state)
    else
      parser1(rest, {:nop}, result,state)
    end
  end

  def parser1(<<_, rest::binary>>, _, result, state) do
    parser1(rest, {:nop}, result, state)
  end

end
