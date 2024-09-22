defmodule GameOfStones.Client do
  def main(args) do
    parse(args)
    |> play()
  end

  def play(initial_stones_num \\ 30) do
    case GameOfStones.Server.set_stones(initial_stones_num) do
      {player, current_stones, :playing} ->
        "Welcome ! It's player #{player} turn. #{current_stones} in the pile."
        |> Colors.green()
        |> IO.puts()

      {player, current_stones, :continue} ->
        "Continuing the game ! It's player #{player} turn. #{current_stones} in the pile."
        |> Colors.red()
        |> IO.puts()
    end

    take()
  end

  defp parse(args) do
    {opts, _, _} = OptionParser.parse(args, switches: [stones: :integer])

    opts
    |> Keyword.get(:stones, Application.get_env(:game_of_stones, :default_stones))
  end

  defp take() do
    case GameOfStones.Server.take(ask_stones()) do
      {:next_turn, next_player, stones_count} ->
        IO.puts("\nPlayer #{next_player} turns next. Stones #{stones_count}.")
        take()

      {:winner, winner} ->
        IO.puts("\nPlayer #{winner} won !")

      {:error, reason} ->
        IO.puts(~s(\n There was an error: "#{reason}"\n))
        take()
    end
  end

  defp ask_stones() do
    IO.gets("How many stones (1 to 3) do you want to take ? ")
    |> String.trim()
    |> Integer.parse()
    |> stones_to_take()
  end

  defp stones_to_take({count, _}), do: count
  defp stones_to_take(:error), do: 0
end
