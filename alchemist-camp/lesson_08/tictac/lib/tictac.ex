defmodule Tictac do
  alias Tictac.{Square, State}

  def start(ui) do
    with {:ok, game} <- State.new(ui),
         player <- ui.(game, :get_player),
         {:ok, game} <- State.event(game, {:choose_p1, player}) do
      handle(game)
    else
      (error -> error)
    end
  end

  def check_player(player) do
    case player do
      :x -> {:ok, player}
      :o -> {:ok, player}
      _ -> {:error, :invalid_player}
    end
  end

  def game_over?(game) do
    board_full? = Enum.all?(game.board, fn {_, v} -> v != :empty end)
    if board_full? or game.winner, do: :game_over, else: :not_over
  end

  def get_col(board, col) do
    for {%{col: c, row: _}, v} <- board, col == c, do: v
  end

  def get_row(board, row) do
    for {%{col: _, row: r}, v} <- board, row == r, do: v
  end

  def get_diagonals(board) do
    [
      for({%{col: c, row: r}, v} <- board, c == r, do: v),
      for({%{col: c, row: r}, v} <- board, c + r == 4, do: v)
    ]
  end

  def handle(%{status: :playing} = game) do
    player = game.turn

    with {col, row} <- game.ui.(game, :request_move),
         {:ok, board} <- play_at(game.board, col, row, game.turn),
         {:ok, game} <- State.event(%{game | board: board}, {:play, game.turn}),
         won? <- win_check(board, player),
         {:ok, game} <- State.event(game, {:check_for_winner, won?}),
         over? <- game_over?(game),
         {:ok, game} <- State.event(game, {:game_over?, over?}),
         do: handle(game),
         else: (error -> error)
  end

  def handle(%{status: :game_over} = game) do
    game.ui.(game, nil)
  end

  def place_piece(board, place, player) do
    case board[place] do
      nil -> {:error, :invalid_location}
      :x -> {:error, :occupied}
      :o -> {:error, :occupied}
      :empty -> {:ok, %{board | place => player}}
    end
  end

  def play_at(board, col, row, player) do
    with {:ok, valid_player} <- check_player(player),
         {:ok, square} <- Square.new(col, row),
         {:ok, new_board} <- place_piece(board, square, valid_player) do
      {:ok, new_board}
    else
      (error -> error)
    end
  end

  def win_check(board, player) do
    cols = Enum.map(1..3, &get_col(board, &1))
    rows = Enum.map(1..3, &get_row(board, &1))
    diagonals = get_diagonals(board)

    win? = Enum.any?(cols ++ rows ++ diagonals, &won_line(&1, player))

    if win?, do: player, else: false
  end

  def won_line(line, player), do: Enum.all?(line, &(player == &1))
end
