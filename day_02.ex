Mix.install([{:req, "~> 0.5.5"}])

defmodule DayTwo do
  def check_safety([a, b | _] = list) when a > b, do: decreasing_safe?(list)
  def check_safety([a, b | _] = list) when a < b, do: increasing_safe?(list)
  def check_safety(_), do: false

  def decreasing_safe?([a, b | rest]) when a - b <= 3 and a - b > 0,
    do: decreasing_safe?([b | rest])

  def decreasing_safe?([_]), do: true
  def decreasing_safe?(_), do: false

  def increasing_safe?([a, b | rest]) when b - a <= 3 and b - a > 0,
    do: increasing_safe?([b | rest])

  def increasing_safe?([_]), do: true
  def increasing_safe?(_), do: false

  def check_tolerable_safety(list) do
    Enum.map(0..(Kernel.length(list) - 1), fn x -> check_safety(List.delete_at(list, x)) end)
    |> Enum.reject(&(not &1))
    |> Enum.count() >= 1
  end
end

Req.Request.new(method: :get, url: "https://adventofcode.com/2024/day/2/input")
|> Req.Request.put_header(
  "Cookie",
  "session=53616c7465645f5f0aa2ee598e596e25596cf3b69101fcafcf06dce7dd17310909796733eed28406a1fd060509ab3ad81bb7f766eac141fb154a4cf39c54a5fa;"
)
|> Req.Request.run_request()
|> Kernel.elem(1)
|> Map.get(:body)
|> String.split("\n")
|> Enum.map(fn report ->
  String.split(report, ~r{\s}, trim: true) |> Enum.map(&String.to_integer/1)
end)
# Uncomment the line below to solve part 1
# |> Enum.map(&DayTwo.check_safety/1)
|> Enum.map(&DayTwo.check_tolerable_safety/1)
|> Enum.reject(&(not &1))
|> Enum.count()
|> IO.inspect()
