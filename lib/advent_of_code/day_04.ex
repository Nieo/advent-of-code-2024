defmodule AdventOfCode.Day04 do
  def part1(args) do
    args
    |> parse(0, 0, %{})
    |> search
  end

  def parse(<<>>, _, _, result) do
    result
  end

  def parse(<<"\n", rest::binary>>, row, _, result) do
    parse(rest, row + 1, 0, result)
  end

  def parse(<<c, rest::binary>>, row, col, result) do
    parse(rest, row, col + 1, Map.put(result, %{r: row, c: col}, List.to_string([c])))
  end

  def search(data) do
    data
    |> Enum.filter(fn {_, v} -> v == "X" end)
    |> Enum.map(fn {k, _} -> search_x(k, data) end)
    |> Enum.sum()
  end

  def search_x(%{r: r, c: c}, grid) do
    for x <- -1..1, y <- -1..1 do
      search_next(["M", "A", "S"], %{r: r + x, c: c + y}, {x, y}, grid)
    end
    |> Enum.sum()
  end

  def search_next([l | rest], %{r: r, c: c} = k, {x, y}, grid) do
    case Map.get(grid, k) == l do
      true ->
        case rest == [] do
          true -> 1
          false -> search_next(rest, %{r: r + x, c: c + y}, {x, y}, grid)
        end

      false ->
        0
    end
  end

  def part2(args) do
    args
    |> parse(0, 0, %{})
    |> search2
  end

  def search2(data) do
    data
    |> Enum.filter(fn {_, v} -> v == "A" end)
    |> Enum.count(fn {k, _} -> search_a(k, data) end)
    # |> dbg
  end

  def search_a(%{r: r, c: c}, data) do
    [{1, 1}, {1, -1}, {-1, -1}, {-1, 1}]
    |> Enum.map(fn {x, y} -> Map.get(data, %{r: r + x, c: c + y}) end)
    |> is_x()
    # |> dbg
  end

  def is_x(["M", "M", "S", "S"]), do: true
  def is_x(["S", "M", "M", "S"]), do: true
  def is_x(["S", "S", "M", "M"]), do: true
  def is_x(["M", "S", "S", "M"]), do: true
  def is_x(_), do: false
end
