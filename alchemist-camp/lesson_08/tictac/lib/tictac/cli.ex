defmodule Tictac.Cli do
  alias Tictac.{State, Cli}

  def play() do
    Tictac.start(&Cli.handle/2)
  end

  def handle(%State{status: :initial}, :get_player) do
    IO.gets("Which player will go first ? x or o ? ")
    |> String.trim()
    |> String.to_atom()
  end

  def handle(%State{status: :playing} = state, :request_move) do
    display_board(state.board)
    col = IO.gets("Column: ") |> trimmed_int
    row = IO.gets("Row: ") |> trimmed_int
    {col, row}
  end

  def handle(%State{status: :game_over} = state, _) do
    display_board(state.board)

    case state.winner do
      :tie -> "Another tie?"
      _ -> "Player #{state.winner} won!"
    end
  end

  def show(board, c, r) do
    [item] = for {%{col: col, row: row}, v} <- board, col == c, row == r, do: v
    if item == :empty, do: " ", else: to_string(item)
  end

  def display_board(board) do
    IO.puts("""
      #{show(board, 1, 1)} | #{show(board, 2, 1)} | #{show(board, 3, 1)}
      --------
      #{show(board, 1, 2)} | #{show(board, 2, 2)} | #{show(board, 3, 2)}
      --------
      #{show(board, 1, 3)} | #{show(board, 2, 3)} | #{show(board, 3, 3)}
    """)
  end

  def trimmed_int(str) do
    str |> String.trim() |> String.to_integer()
  end
end
