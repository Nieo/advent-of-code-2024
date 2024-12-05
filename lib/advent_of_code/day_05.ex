defmodule AdventOfCode.Day05 do
  def part1(args) do
    {rules, prints} = parse(args)

    prints
    |> Enum.filter(fn p -> validate(Map.keys(p), p, rules) end)
    |> Enum.map(fn %{mid: mid} -> String.to_integer(mid) end)
    |> Enum.sum()

  end

  def parse(text) do
    [unparsed_rules, unparsed_prints] = String.split(text, "\n\n")

    rules =
      unparsed_rules
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "|", trim: true))
      |> Enum.reduce(%{}, fn [a, b], acc -> Map.update(acc, a, [b], fn curr -> [b | curr] end) end)

    prints =
      unparsed_prints
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ",", trim: true))
      |> Enum.map(&parse_pages(&1, 0, %{mid: Enum.at(&1, (length(&1) - 1) |> div(2))}))

    {rules, prints}
  end

  def parse_pages([], _, result), do: result

  def parse_pages([page | pages], i, result) do
    parse_pages(pages, i + 1, Map.put(result, page, i))
  end

  def validate([], _, _), do: true
  def validate([:mid | xs], pages, rules), do: validate(xs, pages, rules)

  def validate([x | xs], pages, rules) do
    case page_valid(x, pages, rules) do
      true -> validate(xs, pages, rules)
      false -> false
    end
  end

  def page_valid(page, pages, rules) do
    case Map.get(rules, page) do
      nil ->
        true

      rs ->
        rs
        |> Enum.map(fn key -> Map.get(pages, key) end)
        |> Enum.filter(&(&1 != nil))
        |> Enum.filter(&(&1 < Map.get(pages, page))) ==
          []
    end
  end

  def part2(args) do
    {rules, prints} = parse(args)
    prints
    |> Enum.filter(fn p -> !validate(Map.keys(p), p, rules) end)
    |> Enum.map(&reorder(&1, rules))
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def reorder(prints, rules) do
    values = Map.keys(prints)
      |> Enum.filter(&is_binary/1)
    values
    |> Enum.sort(fn a, b -> Enum.any?(Map.get(rules, a, []), &(&1 == b)) end)
    |> Enum.at((length(values)|> div(2)))
  end
end
