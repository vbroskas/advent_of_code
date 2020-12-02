defmodule D3P2 do
  @moduledoc """
  isntead of trying to keep track of two sets of {x,y} corrds at once I just split the OG list into even and odd indexes and then merged
  the two resulting maps
  """
  def present_count() do
    list =
      "inputs/D3.txt"
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> Stream.flat_map(&String.graphemes/1)
      |> Enum.to_list()

    santa =
      Enum.take_every(list, 2)
      |> parse()

    robo_santa =
      Enum.drop_every(list, 2)
      |> parse()

    Map.merge(santa, robo_santa, fn _k, v1, v2 -> v1 + v2 end)
    |> Enum.count()
  end

  def parse(list, coords_map \\ %{}, current_coords \\ {0, 0})

  def parse([], coords_map, {x, y}) do
    Map.update(coords_map, {x, y}, 1, fn current_value ->
      current_value + 1
    end)
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
