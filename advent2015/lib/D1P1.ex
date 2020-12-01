defmodule D1P1 do
  def parse() do
    "inputs/prob1.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.flat_map(&String.split/1)
    |> Stream.flat_map(&String.graphemes/1)
    |> Enum.reduce(0, fn x, acc ->
      case x do
        "(" -> acc + 1
        ")" -> acc - 1
      end
    end)
  end
end
