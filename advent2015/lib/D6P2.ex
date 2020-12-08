defmodule D6P2 do
  @rejects ["turn", "through", "\n"]

  @doc """
  after cleaning input each element in the format:
  ["off", "316", "684", "369", "876"]
  ["toggle", "209", "584", "513", "802"]
  ["on", "583", "543", "846", "710"]

  """
  def get_instructions() do
    :ets.new(:lights_table, [:set, :protected, :named_table])

    "inputs/D6.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.replace(&1, @rejects, ""))
    |> Stream.map(&String.split(&1, [" ", ","], trim: true))
    |> Enum.each(fn set -> calc_lights_on(set) end)

    :ets.match_object(:lights_table, {:_, :_})
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.sum()
  end

  def calc_lights_on(instructions)

  def calc_lights_on([
        "toggle",
        x_start,
        y_start,
        x_end,
        y_end
      ]) do
    create_temp_list(x_start, y_start, x_end, y_end)
    |> Enum.each(fn [x, y] ->
      # update_counter(Tab, Key, Incr, Default)
      :ets.update_counter(:lights_table, [x, y], 2, {[x, y], 0})
    end)
  end

  def calc_lights_on([
        "on",
        x_start,
        y_start,
        x_end,
        y_end
      ]) do
    create_temp_list(x_start, y_start, x_end, y_end)
    # update_counter(Tab, Key, Incr, Default)
    |> Enum.each(fn [x, y] -> :ets.update_counter(:lights_table, [x, y], 1, {[x, y], 0}) end)
  end

  def calc_lights_on([
        "off",
        x_start,
        y_start,
        x_end,
        y_end
      ]) do
    create_temp_list(x_start, y_start, x_end, y_end)
    |> Enum.each(fn [x, y] ->
      # update_counter(Tab, Key, [{Pos, Incr, Threshold, SetValue}], Default)
      :ets.update_counter(:lights_table, [x, y], {2, -1, 0, 0}, {[x, y], 0})
    end)
  end

  @doc """
  creates list of x/y values in the form
  [100, 134],
  """
  def create_temp_list(x_start, y_start, x_end, y_end) do
    for x <- String.to_integer(x_start)..String.to_integer(x_end),
        y <- String.to_integer(y_start)..String.to_integer(y_end),
        do: [x, y]
  end
end
