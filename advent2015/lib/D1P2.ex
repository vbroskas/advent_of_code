defmodule D1P2 do
  def parse() do
    "inputs/prob1.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.flat_map(&String.split/1)
    |> Stream.flat_map(&String.graphemes/1)
    |> Enum.reduce_while({0, 0}, fn x, {acc, count} ->
      acc = check_bracket(x, acc)

      case acc do
        -1 -> {:halt, count + 1}
        _ -> {:cont, {acc, count + 1}}
      end
    end)
  end

  defp check_bracket("(", acc) do
    acc + 1
  end

  defp check_bracket(")", acc) do
    acc - 1
  end
end
