defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  @input "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

  import AdventOfCode.Day03

  test "part1" do
    result = part1(@input)

    assert result == 161
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
