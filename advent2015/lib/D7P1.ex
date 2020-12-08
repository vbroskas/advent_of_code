defmodule D7P1 do
  use Bitwise

  @doc """
  after sorting by length:
  ["0", "->", "c"],
  ["14146", "->", "b"],
  ["lx", "->", "a"],
  ["NOT", "lk", "->", "ll"],
  ["NOT", "go", "->", "gp"],
  ["NOT", "ag", "->", "ah"],
  ["NOT", "bw", "->", "bx"],

  """
  def get_instructions() do
    "inputs/D7.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.split/1)
    |> Enum.to_list()
    |> Enum.sort_by(&length/1)
  end

  @doc """
  123 -> x
  gj OR gu -> gv
  aj AND al -> am
  NOT ac -> ad
  lc LSHIFT 1 -> lw
  gj RSHIFT 1 -> hc
  """
  def match_string([num, "->", wire]) do
  end

  def match_string([wire_1, "OR", wire_2, "->", wire_3]) do
    wire_3_val = bor(String.to_integer(wire_1), String.to_integer(wire_2))
    # put wire_3 in map with wire_3_value
  end

  def match_string([wire_1, "AND", wire_2, "->", wire_3]) do
    wire_3_val = band(String.to_integer(wire_1), String.to_integer(wire_2))
    # put wire_3 in map with wire_3_value
  end

  def match_string(["NOT", wire_1, "->", wire_2]) do
    wire_2_val = bnot(String.to_integer(wire_1))
  end

  def match_string([wire_1, "LSHIFT", num, "->", wire_2]) do
    wire_2_val = bsl(String.to_integer(wire_1), String.to_integer(num))
  end

  def match_string([wire_1, "RSHIFT", num, "->", wire_2]) do
    wire_2_val = bsr(String.to_integer(wire_1), String.to_integer(num))
  end
end
