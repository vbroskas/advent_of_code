defmodule D2P2 do
  # l x w x h
  def get_ribbon_length() do
    "inputs/D2.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.flat_map(&String.split/1)
    |> Stream.map(&String.split(&1, "x"))
    |> Enum.reduce(0, fn dims, acc ->
      acc + calc_ribbon_length(dims)
    end)
  end

  defp calc_ribbon_length(dims) do
    dims = Enum.map(dims, &String.to_integer/1)
    [a, b, c] = Enum.sort(dims)
    2 * a + 2 * b + a * b * c
  end
end
