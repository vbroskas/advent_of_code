defmodule D5P2 do
  def find_nice_string do
    "inputs/D5.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.flat_map(&String.split/1)
    |> Enum.reduce(0, fn x, acc ->
      case check_for_goods(x) do
        true -> acc + 1
        false -> acc
      end
    end)
  end

  def check_for_goods(string) do
    with true <- check_for_triple(string),
         true <- check_for_repeat_pairs(string) do
      true
    else
      false -> false
    end
  end

  @doc """
  ex. "xyx" "abcdefeghi" "aaa" rxexcbwhiywwwwnu
  """
  def check_for_triple(string) do
    String.graphemes(string)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.reduce(false, fn set, acc ->
      case check_set(set) do
        true -> true
        false -> acc
      end
    end)
  end

  @doc """
  pattern match on two of same char with single char betweent them
  """
  def check_set([a, _, a]) do
    true
  end

  def check_set(_) do
    false
  end

  @doc """
  looking for something like 'xyxy' or 'aabcdefgaa' or 'rxexcbwhiywwwwnu'
  """
  def check_for_repeat_pairs(string) do
    case String.match?(string, ~r/([a-z]{2}).*?(\1)/) do
      true -> true
      false -> false
    end
  end
end
