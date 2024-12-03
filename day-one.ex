Mix.install([{:req, "~> 0.5.5"}])

defmodule DayOne do
  def create_lists(input, left \\ [], right \\ [])
  def create_lists([""], left, right), do: {Enum.sort(left), Enum.sort(right)}

  def create_lists([next_line | rest], left, right) do
    [l, r] = String.split(next_line, ~r{\s}, trim: true)
    create_lists(rest, [String.to_integer(l) | left], [String.to_integer(r) | right])
  end

  def find_distances(lists, distances \\ [])
  def find_distances({[], []}, distances), do: distances

  def find_distances({[l | left], [r | right]}, distances),
    do: find_distances({left, right}, [Kernel.abs(l - r) | distances])

  def find_distances_in_repetition(lists, distances \\ [])
  def find_distances_in_repetition({[], _}, distances), do: distances

  def find_distances_in_repetition({[l | left], right}, distances) do
    filtered_left = Enum.reject(left, fn x -> x == l end)

    find_distances_in_repetition({filtered_left, right}, [
      l * Enum.count(right, fn x -> x == l end) | distances
    ])
  end
end

Req.Request.new(method: :get, url: "https://adventofcode.com/2024/day/1/input")
|> Req.Request.put_header(
  "Cookie",
  "session=53616c7465645f5f0aa2ee598e596e25596cf3b69101fcafcf06dce7dd17310909796733eed28406a1fd060509ab3ad81bb7f766eac141fb154a4cf39c54a5fa;"
)
|> Req.Request.run_request()
|> Kernel.elem(1)
|> Map.get(:body)
|> String.split("\n")
|> DayOne.create_lists()
# Uncomment the line below to solve part 1
# |> DayOne.find_distances
# |> Enum.sum
|> DayOne.find_distances_in_repetition()
|> Enum.sum()
|> IO.inspect()
