defmodule AdventOfCode.Day06 do
  def part1(args) do
    {{dir, pos}, map} = parse(args, 0, 0, {nil, %{}})

    map
    |> move(pos, dir)
    |> score
  end

  def parse(<<>>, _, _, result) do
    result
  end

  def parse(<<"\n", rest::binary>>, row, _, result) do
    parse(rest, row + 1, 0, result)
  end

  def parse(<<char, rest::binary>>, row, col, {_, map}) when char in [?^, ?<, ?>, ?v] do
    parse(
      rest,
      row,
      col + 1,
      {{arrow_to_direction(char), {row, col}}, Map.put(map, {row, col}, ".")}
    )
  end

  def parse(<<char, rest::binary>>, row, col, {guard, map}) do
    parse(
      rest,
      row,
      col + 1,
      {guard,
       Map.put(
         map,
         {row, col},
         case char do
           ?. -> "."
           ?# -> "#"
         end
       )}
    )
  end

  def arrow_to_direction(?^), do: {-1, 0}
  def arrow_to_direction(?<), do: {0, -1}
  def arrow_to_direction(?>), do: {0, 1}
  def arrow_to_direction(?v), do: {1, 0}

  def rotate({0, -1}), do: {-1, 0}
  def rotate({-1, 0}), do: {0, 1}
  def rotate({1, 0}), do: {0, -1}
  def rotate({0, 1}), do: {1, 0}

  def move(map, {r, c}, {x, y}) do
    updated = Map.replace(map, {r, c}, "X")

    case Map.get(map, {r + x, c + y}) do
      "#" -> move(updated, {r, c}, rotate({x, y}))
      "." -> move(updated, {r + x, c + y}, {x, y})
      "X" -> move(updated, {r + x, c + y}, {x, y})
      nil -> updated
    end
  end

  def score(map) do
    map
    |> Map.values()
    |> Enum.filter(&(&1 == "X"))
    |> Enum.count()

    # |> dbg
  end

  def print(map) do
    for x <- 0..9, y <- 0..9 do
      Map.get(map, {x, y})
    end
    |> Enum.chunk_every(10)
  end

  def part2(args) do
    {{dir, pos}, map} = parse(args, 0, 0, {nil, %{}})

    map
    |> Enum.filter(fn {k, v} -> v == "." && k != pos end)
    |> Enum.map(fn {k, _} -> k end)
    |> Task.async_stream(fn k ->
      map
      |> Map.update!(k, fn _ -> "#" end)
      |> loop?(pos, dir)
    end)
    |> Enum.map(fn {:ok, result} -> result end)
    |> Enum.sum()
  end

  def filter_loops({:ok, _, _}), do: true
  def filter_loops({:nop}), do: false

  def move2(map, {r, c}, {x, y}, result \\ []) do
    case Map.get(map, {r + x, c + y}) do
      "." -> move2(map, {r + x, c + y}, {x, y}, [is_loop?(map, {r, c}, {x, y}) | result])
      "#" -> move2(map, {r, c}, rotate({x, y}), result)
      nil -> result
    end
  end

  def is_loop?(map, {r, c}, {x, y}) do
    loop?(Map.replace(map, {r + x, c + y}, "#"), {r, c}, rotate({x, y}))
  end

  def loop?(map, {r, c}, {x, y}) do
    updated = Map.update(map, {r, c}, {x, y}, &trace(&1, {x, y}))

    case Map.get(map, {r + x, c + y}) do
      {^x, ^y} -> 1
      "#" -> loop?(updated, {r, c}, rotate({x, y}))
      "." -> loop?(updated, {r + x, c + y}, {x, y})
      {_, _} -> loop?(updated, {r + x, c + y}, {x, y})
      nil -> 0
    end
  end

  def trace(a, _) when is_tuple(a), do: a
  def trace(".", t), do: t
end
