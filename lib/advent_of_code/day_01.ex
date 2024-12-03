defmodule AdventOfCode.Day01 do

  import Enum

  def part1(args) do
  args
    |> String.split("\n", trim: true)
    |> map(fn s ->
      String.split(s, " ", trim: true)
      |> map(&String.to_integer/1)
    end)
    |> zip
    |> map(&Tuple.to_list/1)
    |> map(&sort/1)
    |> zip_with(fn [a, b] -> abs(b - a) end)
    |> sum
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> map(fn s ->
      String.split(s, " ", trim: true)
      |> map(&String.to_integer/1)
    end)
    |> zip
    |> map(&Tuple.to_list/1)
    |> case do
      [a, b] ->
        f = frequencies(b)

        a
        |> map(fn i -> Map.get(f, i, 0) * i end)
        |> sum
    end
  end
end
