defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  @input "23331331214141314024"

  test "part1" do
    result = part1(@input)

    assert result == 1928

    r2 = p1(@input)
    assert r2 == 1928
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
