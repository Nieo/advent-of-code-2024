defmodule AdventOfCode.Day09 do
  def part1(args) do
    {result, size} = parse_file(args, 0, 0, %{})
    compact(result, 0, next_filled(result, size - 1))
    |> Enum.reject(fn {_, v} -> v == "." end)
    |> Enum.reduce(0, fn {k,v}, acc -> acc + k * v end)
  end
  def parse_file(<<"">>, _, total_size, result) do
    {result, total_size}
  end

  def parse_file(<<"\n">>, _, total_size, result) do
    {result, total_size}
  end

  def parse_file(<<char, rest::binary>>, file_index, total_size, result) do
    num = char - 48

    blocks =
      for x <- total_size..(total_size + num - 1) do {x, file_index}
      end
      |> Map.new()

    parse_space(rest, file_index + 1, total_size + num , Map.merge(result, blocks))
  end

  def parse_space(<<>>, _, total_size, result) do
    {result, total_size}
  end
  def parse_space(<<"\n">>, _, total_size, result) do
    {result, total_size}
  end

  def parse_space(<<"0", rest::binary>>, file_index, total_size, result) do
    parse_file(rest, file_index, total_size, result)
  end

  def parse_space(<<char, rest::binary>>, file_index, total_size, result) do
    num = char - 48

    blocks =
      for x <- total_size..(total_size + num - 1) do
        {x, "."}
      end
      |> Map.new()

    parse_file(rest, file_index, total_size + num, Map.merge(result, blocks))
  end

  def compact(data, last_filled, move_idx) do
    case next_empty(data, last_filled + 1, move_idx) do
      :done -> data
      x ->
        to_move = Map.get(data, move_idx)
        data
        |> Map.delete(move_idx)
        |> Map.replace(x, to_move)
        |> compact(x, next_filled(data, move_idx - 1))
    end
  end

  def next_empty(_, pos, max) when pos >= max do
    :done
  end

  def next_empty(data, pos, max) do
    case Map.get(data, pos) do
      "." -> pos
      _ -> next_empty(data, pos + 1, max)
    end
  end

  def next_filled(data, pos) do
    case Map.get(data, pos) do
      "." -> next_filled(data, pos - 1)
      _ -> pos
    end
  end

  def part2(_args) do
  end
end
