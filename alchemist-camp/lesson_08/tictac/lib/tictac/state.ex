defmodule Tictac.State do
  alias Tictac.{Square, State}
  @players [:x, :o]

  defstruct status: :initial,
            turn: nil,
            winner: nil,
            board: Square.new_board(),
            ui: nil

  def new(), do: {:ok, %State{}}
  def new(ui), do: {:ok, %State{ui: ui}}

  def event(%State{status: :initial} = state, {:choose_p1, player}) do
    case Tictac.check_player(player) do
      {:ok, p} -> {:ok, %State{state | status: :playing, turn: p}}
      _ -> {:error, :invalid_player}
    end
  end

  def event(%State{status: :playing}, {:play, p}) when p not in @players do
    {:error, :invalid_player}
  end

  def event(%State{status: :playing, turn: p} = state, {:play, p}) do
    {:ok, %State{state | turn: other_player(p)}}
  end

  def event(%State{status: :playing}, {:play, _}), do: {:error, :out_of_turn}

  def event(%State{status: :playing} = state, {:check_for_winner, winner}) do
    win_state = %State{state | status: :game_over, turn: nil, winner: winner}

    case winner do
      :x ->
        {:ok, win_state}

      :o ->
        {:ok, win_state}

      _ ->
        {:ok, state}
    end
  end

  def event(%State{status: :playing} = state, {:game_over?, over_or_not}) do
    case over_or_not do
      :not_over -> {:ok, state}
      :game_over -> {:ok, %State{state | status: :game_over, winner: :tie}}
      _ -> {:error, :invalid_game_over_status}
    end
  end

  def event(%State{status: :game_over} = state, {:game_over?, _}), do: {:ok, state}

  def event(state, action) do
    {:error, {:invalid_state_transition, %{status: state.status, action: action}}}
  end

  def other_player(p) do
    case p do
      :x -> :o
      :o -> :x
    end
  end
end
