defmodule D6P1 do
  @rejects ["turn", "through", "\n"]

  # TODO add in ETS table for store!

  def get_instructions() do
    {num_lights_on, _current_on} =
      "inputs/D6.txt"
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> Stream.map(&String.replace(&1, @rejects, ""))
      |> Stream.map(&String.split(&1, [" ", ","], trim: true))
      |> Enum.reduce({0, []}, fn x, {_acc, current_on} ->
        calc_lights_on(x, current_on)
      end)

    num_lights_on
  end

  def calc_lights_on(instructions, current_on)

  def calc_lights_on(
        [
          "toggle",
          x_start,
          y_start,
          x_end,
          y_end
        ],
        current_on
      ) do
    temp_list = create_temp_list(x_start, y_start, x_end, y_end)
    find_toggles(temp_list, current_on)
  end

  def calc_lights_on(
        [
          "on",
          x_start,
          y_start,
          x_end,
          y_end
        ],
        current_on
      ) do
    temp_list = create_temp_list(x_start, y_start, x_end, y_end)
    current_on = add_to_list(temp_list, current_on)
    num_on = Enum.count(current_on)
    {num_on, current_on}
  end

  def calc_lights_on(
        [
          "off",
          x_start,
          y_start,
          x_end,
          y_end
        ],
        current_on
      ) do
    temp_list = create_temp_list(x_start, y_start, x_end, y_end)
    current_on = remove_from_list(temp_list, current_on)
    num_on = Enum.count(current_on)
    {num_on, current_on}
  end

  def create_temp_list(x_start, y_start, x_end, y_end) do
    for x <- String.to_integer(x_start)..String.to_integer(x_end),
        y <- String.to_integer(y_start)..String.to_integer(y_end),
        do: [x, y]
  end

  def remove_from_list(temp_list, current_list) do
    current_list -- temp_list
  end

  def add_to_list(temp_list, current_list) do
    (temp_list ++ current_list) |> Enum.uniq()
  end

  def find_toggles(temp_list, current_on) do
    matching_on = Enum.filter(current_on, fn el -> Enum.member?(temp_list, el) end)
    current_on = (current_on -- matching_on) ++ (temp_list -- matching_on)
    num_on = Enum.count(current_on)
    {num_on, current_on}
  end
end

# toggle 461,550 through 564,900
# turn off 370,39 through 425,839
# turn off 464,858 through 833,915
# turn off 812,389 through 865,874
# turn on 599,989 through 806,993
# turn on 376,415 through 768,548
# turn on 606,361 through 892,600
# turn off 448,208 through 645,684

# turn on 0,0 through 4,4
# toggle 0,0 through 1,1
# toggle 1,1 through 2,2
