Mix.install([{:req, "~> 0.5.5"}])

defmodule DayFive do
  def startup_printer(input) do
    [rules, messages] = input |> String.split("\n\n") |> Enum.map(&String.split(&1, "\n"))

    rules =
      rules
      |> Enum.reduce(%{}, fn rule, acc ->
        [key, value] = String.split(rule, "|")

        case Map.get(acc, value) do
          nil -> Map.put(acc, value, [key])
          vals -> Map.put(acc, value, [key | vals])
        end
      end)

    messages = messages |> Enum.map(&String.split(&1, ","))

    [rules, messages]
  end

  def validate_message(_, [""], _), do: {:error}
  def validate_message(_, [_], mid_value), do: {:ok, mid_value}

  def validate_message(rules, message, mid_value) do
    [first | rest] = message

    case Map.get(rules, first) do
      nil ->
        validate_message(rules, rest, mid_value)

      forbidden_values ->
        case forbidden_values |> Enum.any?(&Enum.member?(rest, &1)) do
          true -> {:error}
          false -> validate_message(rules, rest, mid_value)
        end
    end
  end
end

Req.Request.new(method: :get, url: "https://adventofcode.com/2024/day/5/input")
|> Req.Request.put_header(
  "Cookie",
  "session=53616c7465645f5f0aa2ee598e596e25596cf3b69101fcafcf06dce7dd17310909796733eed28406a1fd060509ab3ad81bb7f766eac141fb154a4cf39c54a5fa;"
)
|> Req.Request.run_request()
|> Kernel.elem(1)
|> Map.get(:body)
|> DayFive.startup_printer()
|> Kernel.then(fn [rules, messages] -> Enum.map(messages, &DayFive.validate_message(rules, &1, Enum.at(&1, Kernel.trunc(Float.floor(Kernel.length(&1) / 2))))) end)
|> Enum.filter(fn result -> elem(result, 0) == :ok end)
|> Enum.map(&elem(&1, 1) |> String.to_integer())
|> Enum.sum()
|> IO.inspect(limit: :infinity)

~s(47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47)
|> DayFive.startup_printer()
|> Kernel.then(fn [rules, messages] -> Enum.map(messages, &DayFive.validate_message(rules, &1, Enum.at(&1, Kernel.trunc(Float.floor(Kernel.length(&1) / 2))))) end)
|> Enum.filter(fn result -> elem(result, 0) == :ok end)
|> Enum.map(&elem(&1, 1) |> String.to_integer())
|> Enum.sum()
|> IO.inspect()
