Mix.install([{:req, "~> 0.5.5"}])

defmodule DayFour do
  @cardinal_directions [[0, 1], [0, -1], [1, 0], [-1, 0]]
  @ordinal_directions [[-1, 1], [-1, -1], [1, -1], [1, 1]]

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
              Enum.map(@cardinal_directions ++ @ordinal_directions, fn [x, y] ->
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

  def mas(
        input,
        line \\ 0,
        column \\ 0,
        direction \\ [0, 1],
        target_letter \\ "A",
        mas_found \\ 0
      )

  def mas(_, line, column, _, _, _) when line < 0 or column < 0, do: {:nok}

  def mas(input, line, column, _, "A", mas_found) do
    case Enum.at(input, line) do
      nil ->
        {:finished, mas_found}

      target_line ->
        case String.at(target_line, column) do
          "A" ->
            founds =
              Enum.map(@ordinal_directions, fn [x, y] ->
                mas(input, line + x, column + y, [x, y], "M")
              end)
              |> Enum.count(fn {x} -> x == :ok end)

            if founds === 2 do
              mas(input, line, column + 1, [0, 1], "A", mas_found + 1)
            else
              mas(input, line, column + 1, [0, 1], "A", mas_found)
            end

          nil ->
            mas(input, line + 1, 0, [0, 1], "A", mas_found)

          _ ->
            mas(input, line, column + 1, [0, 1], "A", mas_found)
        end
    end
  end

  def mas(input, line, column, [x, y], target_letter, mas_found) do
    case Enum.at(input, line) do
      nil ->
        {:nok}

      target_line ->
        case String.at(target_line, column) do
          letter ->
            if letter == target_letter do
              case letter do
                "M" ->
                  mas(input, line + x * -2, column + y * -2, [x * -2, y * -2], "S", mas_found)

                "S" ->
                  {:ok}

                _ ->
                  {:nok}
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
# Uncomment the line below to solve part 1
# |> DayFour.xmas()
|> DayFour.mas()
|> IO.inspect()
