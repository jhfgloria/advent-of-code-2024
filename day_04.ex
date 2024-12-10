Mix.install([{:req, "~> 0.5.5"}])

defmodule DayFour do
  @coordinates [[0, 1], [0, -1], [1, 0], [-1, 0], [-1, 1], [-1, -1], [1, -1], [1, 1]]

  def xmas(
        input,
        line \\ 0,
        column \\ 0,
        direction \\ [0, 1],
        target_letter \\ "X",
        xmas_found \\ 0
      )

  def xmas(_, line, column, _, _, _) when line < 0 or column < 0, do: {:nok}

  def xmas(input, line, column, _, "X", xmas_found) do
    case Enum.at(input, line) do
      nil ->
        {:finished, xmas_found}

      target_line ->
        case String.at(target_line, column) do
          "X" ->
            founds =
              Enum.map(@coordinates, fn [x, y] ->
                xmas(input, line + x, column + y, [x, y], "M")
              end)
              |> Enum.count(fn {x} -> x == :ok end)

            xmas(input, line, column + 1, [0, 1], "X", xmas_found + founds)

          nil ->
            xmas(input, line + 1, 0, [0, 1], "X", xmas_found)

          _ ->
            xmas(input, line, column + 1, [0, 1], "X", xmas_found)
        end
    end
  end

  def xmas(input, line, column, [x, y] = direction, target_letter, xmas_found) do
    case Enum.at(input, line) do
      nil ->
        {:nok}

      target_line ->
        case String.at(target_line, column) do
          letter ->
            if letter == target_letter do
              case letter do
                "M" -> xmas(input, line + x, column + y, direction, "A", xmas_found)
                "A" -> xmas(input, line + x, column + y, direction, "S", xmas_found)
                "S" -> {:ok}
                _ -> {:nok}
              end
            else
              {:nok}
            end
        end
    end
  end
end


Req.Request.new(method: :get, url: "https://adventofcode.com/2024/day/4/input")
|> Req.Request.put_header(
  "Cookie",
  "session=53616c7465645f5f0aa2ee598e596e25596cf3b69101fcafcf06dce7dd17310909796733eed28406a1fd060509ab3ad81bb7f766eac141fb154a4cf39c54a5fa;"
)
|> Req.Request.run_request()
|> Kernel.elem(1)
|> Map.get(:body)
|> String.split("\n")
|> DayFour.xmas()
|> IO.inspect()
