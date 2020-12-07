defmodule D6P1 do
  # TODO change this from 5 to 999 in final solution
  @initial_off for x <- 0..999, y <- 0..999, do: [x, y]
  @initial_on []
  @rejects ["turn", "through", "\n"]

  def get_instructions() do
    {num_lights_on, _current_on, _current_off} =
      "inputs/D6.txt"
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> Stream.map(&String.replace(&1, @rejects, ""))
      |> Stream.map(&String.split(&1, [" ", ","], trim: true))
      |> Enum.reduce({0, @initial_on, @initial_off}, fn x, {_acc, current_on, current_off} ->
        calc_lights_on(x, current_on, current_off)
      end)

    num_lights_on
  end

  def calc_lights_on(instructions, current_on \\ @initial_on, current_off \\ @initial_off)

  def calc_lights_on(
        [
          "toggle",
          x_start,
          y_start,iex
          x_end,
          y_end
        ],
        current_on,
        current_off
      ) do
    temp_list = create_temp_list(x_start, y_start, x_end, y_end)
    find_toggles(temp_list, current_on, current_off)
  end

  def calc_lights_on(
        [
          "on",
          x_start,
          y_start,
          x_end,
          y_end
        ],
        current_on,
        current_off
      ) do
    # create temp list to compare with current on and off lists
    temp_list = create_temp_list(x_start, y_start, x_end, y_end)
    # add new items(if any) to current list of on lights
    current_on = add_to_list(temp_list, current_on)
    # remove items from current list of off lights
    current_off = remove_from_list(temp_list, current_off)
    # count num elements in on list
    num_on = Enum.count(current_on)

    {num_on, current_on, current_off}
  end

  def calc_lights_on(
        [
          "off",
          x_start,
          y_start,
          x_end,
          y_end
        ],
        current_on,
        current_off
      ) do
    temp_list = create_temp_list(x_start, y_start, x_end, y_end)
    current_on = remove_from_list(temp_list, current_on)
    current_off = add_to_list(temp_list, current_off)
    num_on = Enum.count(current_on)
    {num_on, current_on, current_off}
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

  def find_toggles(temp_list, current_on, current_off) do
    # ON-----------
    matching_on = Enum.filter(current_on, fn el -> Enum.member?(temp_list, el) end)
    # remove matching_on from current_on, and add matching_on to current_off

    # OFF---------
    matching_off = Enum.filter(current_off, fn el -> Enum.member?(temp_list, el) end)
    # remove matching_off from current_off, and add matching_off to current_on
    current_off = (current_off -- matching_off) ++ matching_on
    current_on = (current_on -- matching_on) ++ matching_off
    num_on = Enum.count(current_on)
    {num_on, current_on, current_off}
  end
end

# ["toggle", "461,550", "564,900"]
# ["off", "269,809", "876,847"]
# ["on", "952,417", "954,845"]

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
