Mix.install([{:req, "~> 0.5.5"}])

defmodule DayThree do
  def multiplications(line) do
    Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, line)
    |> Enum.reduce(0, fn [_, a, b], acc -> acc + String.to_integer(a) * String.to_integer(b) end)
  end

  def find_dos(line, is_do \\ true, dos \\ [])

  def find_dos("", _, dos), do: Enum.join(dos)

  def find_dos(line, is_do, dos) do
    {next_is_do, [expression | rest]} = is_do_or_dont?(line)

    case is_do do
      true -> find_dos(Enum.join(rest), next_is_do, dos ++ [expression])
      false -> find_dos(Enum.join(rest), next_is_do, dos)
    end
  end

  defp is_do_or_dont?(line) do
    case Regex.run(~r/do(n\'t)?\(\)?/, line) do
      # two matches means it found a don't ["don't()", "n't"]
      [_, _] -> {false, String.split(line, ~r/do(n\'t)\(\)/, parts: 2)}
      _ -> {true, String.split(line, ~r/do\(\)/, parts: 2)}
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
|> Enum.join()
# Comment the next line to solve Part 1
|> DayThree.find_dos()
|> DayThree.multiplications()
|> IO.inspect()
