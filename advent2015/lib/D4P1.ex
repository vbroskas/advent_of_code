defmodule D4P1 do
  @moduledoc """
  solving part 1 and 2 for day 4 only require changing the pattern match from 5 zeros to 6
  """
  def find_lowest() do
    input = "ckczppom"
    number = 1

    <<head::bytes-size(5), rest::binary>> =
      :crypto.hash(:md5, "#{input}#{number}") |> Base.encode16()

    calc_num(input, number, head)
  end

  def calc_num(input, number \\ 1, head \\ "")

  def calc_num(_input, number, "000000") do
    number
  end

  def calc_num(input, number, _head) do
    number = number + 1

    <<head::bytes-size(6), _rest::binary>> =
      :crypto.hash(:md5, "#{input}#{number}") |> Base.encode16()

    calc_num(input, number, head)
  end
end
