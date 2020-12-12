defmodule D7P2 do
  @moduledoc """
  clean each input row to turn string INTs to INT, and commands to atoms
  iterate over each row, if any wire not found in store, shift that row to end of the list
  Part 2 sets the value for "b" as the value for "a" in D7P1
  """
  use Bitwise

  def commands do
    [
      or: fn w1, w2 -> bor(w1, w2) end,
      and: fn w1, w2 -> band(w1, w2) end,
      lshift: fn w1, w2 -> bsl(w1, w2) end,
      rshift: fn w1, w2 -> bsr(w1, w2) end,
      not: fn w1 -> 65535 - w1 end
    ]
  end

  @replaces %{
    "OR" => :or,
    "AND" => :and,
    "NOT" => :not,
    "LSHIFT" => :lshift,
    "RSHIFT" => :rshift
  }

  @doc """
  after split:
  ["he", :rshift, 1, "->", "hx"],
  [1, :and, "cx", "->", "cy"],
  ...
  """
  def get_instructions() do
    map =
      "inputs/D7.txt"
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> Stream.map(&String.split/1)
      |> Stream.map(&Enum.map(&1, fn x -> check_int(x) end))
      |> Stream.map(&Enum.map(&1, fn x -> replace_commands(x) end))
      |> Enum.to_list()
      |> match_string(%{"b" => 956})

    map["a"]
  end

  def replace_commands(string) do
    case string in ["OR", "AND", "NOT", "LSHIFT", "RSHIFT"] do
      true -> @replaces[string]
      false -> string
    end
  end

  def check_int(item) do
    case Integer.parse(item) do
      {int, _} -> int
      _ -> item
    end
  end

  def match_string([], store) do
    store
  end

  def match_string([[num, "->", wire] = row | _t] = master, store) when is_integer(num) do
    update_store(wire, num, row, master, store)
  end

  def match_string([[w1, "->", w2] = row | _t] = master, store) do
    case check_keys([w1], store) do
      [w1] ->
        w2_val = w1
        update_store(w2, w2_val, row, master, store)

      false ->
        move_row_to_end_of_list(master, row, store)
    end
  end

  def match_string([[w1, cmd, w2, "->", w3] = row | _t] = master, store) do
    case check_keys([w1, w2], store) do
      [w1, w2] ->
        w3_val = Keyword.get(commands(), cmd).(w1, w2)
        update_store(w3, w3_val, row, master, store)

      false ->
        move_row_to_end_of_list(master, row, store)
    end
  end

  def match_string([[:not, w1, "->", w2] = row | _t] = master, store) do
    case check_keys([w1], store) do
      [w1] ->
        w2_val = Keyword.get(commands(), :not).(w1)
        update_store(w2, w2_val, row, master, store)

      false ->
        move_row_to_end_of_list(master, row, store)
    end
  end

  defp update_store(w, w_val, row, master, store) do
    # **only change on part 2 is needed to check if a input wire ("b") is already in the store so we don't override it the first time we find it in the master list
    case Map.has_key?(store, w) do
      true ->
        master = List.delete(master, row)
        match_string(master, store)

      false ->
        store = Map.put(store, w, w_val)
        master = List.delete(master, row)
        match_string(master, store)
    end
  end

  # if any of the wires in a row aren't found in the store,
  # delete that row from the master list and insert it at the end
  defp move_row_to_end_of_list(master, row, store) do
    master
    |> List.delete(row)
    |> List.insert_at(-1, row)
    |> match_string(store)
  end

  # check wires to see if INT, or have store value
  defp check_keys(keys, store) do
    keys = Enum.map(keys, fn key -> process_key(key, store) end)

    case false in keys do
      true -> false
      _ -> keys
    end
  end

  defp process_key(key, store) do
    cond do
      is_integer(key) -> key
      Map.has_key?(store, key) -> store[key]
      true -> false
    end
  end

  def speed do
    Benchee.run(%{"D7P1" => fn -> get_instructions() end})
  end
end
