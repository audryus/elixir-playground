defmodule GameOfStones.GameClient do
  def play(initial_stones_num \\ 30) do
    initial_stones_num
    |> GameOfStones.GameServer.start()

    start_game!()
  end

  def start_game!() do
    case GameOfStones.GameServer.stats() do
      {player, current_stones} ->
        IO.puts("Welcome ! It's player #{player} turn. #{current_stones} in the pile.")
    end

    take()
  end

  defp take() do
    case GameOfStones.GameServer.take(ask_stones()) do
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

defmodule GameOfStones.GameServer do
  use GenServer

  # Interface functions
  def start(inital_stones_num \\ 30)
      when is_integer(inital_stones_num) and
             inital_stones_num > 0 do
    GenServer.start(__MODULE__, inital_stones_num, name: __MODULE__)
  end

  def stats() do
    GenServer.call(__MODULE__, :stats)
  end

  def take(num_stones) when is_integer(num_stones) do
    GenServer.call(__MODULE__, {:take, num_stones})
  end

  # Callbacks

  def init(inital_stones_num) when is_integer(inital_stones_num) do
    {:ok, {1, inital_stones_num}}
  end

  def handle_call(:stats, _, current_state) do
    {:reply, current_state, current_state}
  end

  def handle_call({:take, num_stones}, _, {player, current_stones}) do
    do_take({player, num_stones, current_stones})
  end

  def terminate(_, _) do
    "See you soon" |> IO.puts()
  end

  # Privates
  defp do_take({player, num_stones, current_stones})
       when not is_integer(num_stones) or
              num_stones < 1 or
              num_stones > 3 or
              num_stones > current_stones do
    {:reply,
     {
       :error,
       "You can take 1 to 3 stones, and it should be less than or equal to the number of stones in the pile"
     }, {player, current_stones}}
  end

  defp do_take({player, num_stones, current_stones})
       when num_stones == current_stones do
    {:stop, :normal, {:winner, next_player(player)}, {nil, 0}}
  end

  defp do_take({player, num_stones, current_stones}) do
    next_p = next_player(player)
    new_stones = current_stones - num_stones
    {:reply, {:next_turn, next_p, new_stones}, {next_p, new_stones}}
  end

  defp next_player(1), do: 2
  defp next_player(2), do: 1
end

GameOfStones.GameClient.play(10)
