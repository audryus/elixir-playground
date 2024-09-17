defmodule Tictac.Square do
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_size 1..3

  def new(col, row) when col in @board_size and row in @board_size do
    {:ok, %Tictac.Square{col: col, row: row}}
  end

  def new(_col, _row), do: {:error, :invalid_square}

  def new_board() do
    for s <- squares(), into: %{}, do: {s, :empty}
  end

  def squares() do
    for c <- @board_size, r <- @board_size, into: MapSet.new(), do: %Tictac.Square{col: c, row: r}
  end
end
