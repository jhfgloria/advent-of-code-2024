Mix.install([{:req, "~> 0.5.5"}, {:nimble_parsec, "~> 1.0"}])

defmodule DayThree do
  import NimbleParsec

  multiplication = eventually(ascii_string(not: )) ignore(string("mul(")) |> integer(min: 1, max: 3) |> ignore(string(",")) |> integer(min: 1, max: 3) |> ignore(string(")"))

  defparsec :multiplications, multiplication
end

# Req.Request.new(method: :get, url: "https://adventofcode.com/2024/day/3/input")
# |> Req.Request.put_header(
#   "Cookie",
#   "session=53616c7465645f5f0aa2ee598e596e25596cf3b69101fcafcf06dce7dd17310909796733eed28406a1fd060509ab3ad81bb7f766eac141fb154a4cf39c54a5fa;"
# )
# |> Req.Request.run_request()
# |> Kernel.elem(1)
# |> Map.get(:body)
# |> String.split("\n")
# |> IO.inspect()

IO.inspect DayThree.multiplications("Xmul(2,4)Z")
