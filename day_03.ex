Mix.install([{:req, "~> 0.5.5"}])

defmodule DayThree do
  def multiplications(line) do
    Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, line)
    |> Enum.reduce(0, fn [_, a, b], acc -> acc + String.to_integer(a) * String.to_integer(b) end)
  end

  def complex_multiplications(line) do
    [enabled | rest] = String.split(line, ~s(don't\(\)))
    case Enum.at(rest, 0) do
      nil -> multiplications(enabled)
      rest ->
        [_ | enabled_rest] = Enum.at(rest, 0) |> String.split(~s(do\(\)))
        case Enum.at(enabled_rest, 0) do
          nil -> multiplications(enabled)
          rest -> multiplications(enabled <> rest)
        end
    end
  end
end

Req.Request.new(method: :get, url: "https://adventofcode.com/2024/day/3/input")
|> Req.Request.put_header(
  "Cookie",
  "session=53616c7465645f5f0aa2ee598e596e25596cf3b69101fcafcf06dce7dd17310909796733eed28406a1fd060509ab3ad81bb7f766eac141fb154a4cf39c54a5fa;"
)
|> Req.Request.run_request()
|> Kernel.elem(1)
|> Map.get(:body)
|> String.split("\n")
|> Enum.map(&DayThree.complex_multiplications/1)
|> Enum.sum()
|> IO.inspect()

IO.inspect DayThree.complex_multiplications("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
