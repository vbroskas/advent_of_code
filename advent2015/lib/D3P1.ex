defmodule D3P1 do
  def present_count() do
    "inputs/D3.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.flat_map(&String.graphemes/1)
    |> Enum.to_list()
    |> parse()
  end

  def parse(list, coords_map \\ %{}, current_coords \\ {0, 0})

  def parse([], coords_map, {x, y}) do
    Map.update(coords_map, {x, y}, 1, fn current_value ->
      current_value + 1
    end)
    |> Enum.count()
  end

  def parse(["^" | t], coords_map, {x, y}) do
    new_coords = {x, y + 1}

    coords_map =
      Map.update(coords_map, {x, y}, 1, fn current_value ->
        current_value + 1
      end)

    parse(t, coords_map, new_coords)
  end

  def parse([">" | t], coords_map, {x, y}) do
    new_coords = {x + 1, y}

    coords_map =
      Map.update(coords_map, {x, y}, 1, fn current_value ->
        current_value + 1
      end)

    parse(t, coords_map, new_coords)
  end

  def parse(["v" | t], coords_map, {x, y}) do
    new_coords = {x, y - 1}

    coords_map =
      Map.update(coords_map, {x, y}, 1, fn current_value ->
        current_value + 1
      end)

    parse(t, coords_map, new_coords)
  end

  def parse(["<" | t], coords_map, {x, y}) do
    new_coords = {x - 1, y}

    coords_map =
      Map.update(coords_map, {x, y}, 1, fn current_value ->
        current_value + 1
      end)

    parse(t, coords_map, new_coords)
  end
end
