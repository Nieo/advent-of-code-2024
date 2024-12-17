defmodule AdventOfCode.Day08 do
  def part1(args) do
    {max_row, max_col, coords} =
      args
      |> parse(0, 0, [], 0)

    coords
    |> Enum.group_by(fn {k, _, _} -> k end)
    |> Enum.map(&antinodes/1)
    |> List.flatten()
    |> Enum.filter(&is_tuple/1)
    |> Enum.filter(fn {x, y} -> x >= 0 and x <= max_col and y >= 0 and y <= max_row end)
    |> MapSet.new()
    |> MapSet.size()
  end

  def parse(<<>>, row, _, result, max_col) do
    {row - 1, max_col, result}
  end

  def parse(<<"\n", rest::binary>>, row, col, result, _) do
    parse(rest, row + 1, 0, result, col - 1)
  end

  def parse(<<".", rest::binary>>, row, col, result, mc) do
    parse(rest, row, col + 1, result, mc)
  end

  def parse(<<freq, rest::binary>>, row, col, result, mc) do
    parse(rest, row, col + 1, [{freq, row, col} | result], mc)
  end

  def antinodes({_, nodes}) do
    for {_, x1, y1} <- nodes, {_, x2, y2} <- nodes do
      cond do
        x1 == x2 and y1 == y2 ->
          :nope

        true ->
          dx = x1 - x2
          dy = y1 - y2
          {x1 + dx, y1 + dy}
      end
    end
  end

  def part2(_args) do
  end
end
