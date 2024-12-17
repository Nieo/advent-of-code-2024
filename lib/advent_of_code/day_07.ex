defmodule AdventOfCode.Day07 do
  import Enum, only: [map: 2, filter: 2, sum: 1]
  import String, only: [split: 3, to_integer: 1]

  def part1(args) do
    args
    |> parse
    |> filter(fn {target, params} -> calibrate(target, params, 0) end)
    |> map(fn {i, _} -> i end)
    |> sum()
  end

  def parse(args) do
    args
    |> split("\n", trim: true)
    |> map(&parse_line/1)
  end

  def parse_line(text) do
    [result, params] =
      text
      |> split(":", trim: true)
    {to_integer(result), params |> split(" ", trim: true) |> map(&to_integer/1)}
  end

  def calibrate(target, [], value) do
    target == value
  end

  def calibrate(target, [x | xs], 0) do
    calibrate(target, xs, x)
  end
  def calibrate(target, [x | xs], value ) do
    calibrate(target, xs, value + x) or calibrate(target, xs, value * x)
  end

  def part2(_args) do
  end
end
