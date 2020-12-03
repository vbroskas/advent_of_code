defmodule D5P1 do
  @vowls ~w(a e i o u)
  @bads ~w(ab cd pq xy)
  def find_nice_string do
    "inputs/D5.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.flat_map(&String.split/1)
    |> Enum.reduce(0, fn x, acc ->
      case parse(x) do
        true -> acc + 1
        false -> acc
      end
    end)
  end

  def parse(string) do
    cond do
      check_for_bads(string) -> false
      check_for_goods(string) -> true
      true -> false
    end
  end

  def check_for_bads(string) do
    String.contains?(string, @bads)
  end

  def check_for_goods(string) do
    with true <- check_for_vowels(string),
         true <- check_for_repeats(string) do
      true
    else
      false -> false
    end
  end

  @doc """
  find sequential repeat chars in string
  """
  def check_for_repeats(string) do
    String.graphemes(string)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(false, fn [x, y], acc ->
      cond do
        x == y -> true
        true -> acc
      end
    end)
  end

  @doc """
  # remove all chars but vowels (with filter and string contains?),
  then use Enum.frequencies() and check sum of map values
  """
  def check_for_vowels(string) do
    count =
      String.graphemes(string)
      |> Enum.filter(&String.contains?(&1, @vowls))
      |> Enum.frequencies()
      |> Enum.reduce(0, fn {_k, v}, acc -> v + acc end)

    count >= 3
  end
end
