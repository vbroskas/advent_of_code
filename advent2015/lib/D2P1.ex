defmodule D2P1 do
  # l x w x h
  def get_wrapping_length() do
    "inputs/D2.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.flat_map(&String.split/1)
    |> Stream.map(&String.split(&1, "x"))
    |> Enum.reduce(0, fn dims, acc ->
      acc + calc_length(dims)
    end)
  end

  defp calc_length(dims) do
    [l, w, h] = dims = Enum.map(dims, &String.to_integer/1)
    base_length = 2 * l * w + 2 * w * h + 2 * h * l
    [a, b, _c] = Enum.sort(dims)
    base_length + a * b
  end
end
