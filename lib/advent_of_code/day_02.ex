defmodule AdventOfCode.Day02 do
  import Enum

  def part1(args) do
    args
    |> parse()
    |> map(&check/1)
    |> filter(& &1)
    |> length
  end

  def part2(args) do
    args
    |> parse()
    |> map(&check2/1)
    |> filter(& &1)
    |> length
  end

  defp parse(text) do
    text
    |> String.split("\n", trim: true)
    |> map(fn line -> String.split(line, " ", trim: true) |> map(&String.to_integer/1) end)
  end

  def check([x | xs]) do
    safe(x, xs, :undefined) == :safe
  end

  def safe(_, [], _), do: :safe
  def safe(y, [x | _], _) when x == y, do: :unsafe
  def safe(y, [x | xs], :inc) when x > y and x - 3 <= y, do: safe(x, xs, :inc)
  def safe(y, [x | xs], :dec) when x < y and x + 3 >= y, do: safe(x, xs, :dec)
  def safe(y, [x | xs], :undefined) when x > y and x - 3 <= y, do: safe(x, xs, :inc)
  def safe(y, [x | xs], :undefined) when x < y and x + 3 >= y, do: safe(x, xs, :dec)
  def safe(_, _, _), do: :unsafe

  def check2(levels) do
    case check(levels) do
      :safe ->
        true

      _ ->
        levels
        |> with_index()
        |> any?(fn {_, idx} ->
          List.delete_at(levels, idx) |> check
        end)
    end
  end
end
