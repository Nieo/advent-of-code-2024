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

  def part2(_args) do
  end
end
