defmodule Ch8 do
  def deck(option \\ %{}) do
    suits = ~w(Spades Hearts Clubs Diamonds)
    ranks = rtos(1..10) ++ ~w(Jack Queen King Ace)

    for r <- ranks, s <- suits, do: r <> " of " <> s
  end

  def rtos(range), do: Enum.map(range, &Integer.to_string/1)

  # find triangles with integer side lengths less than n
  def triagles(n) when n < 1, do: []

  def triagles(n) do
    for a <- 1..n,
        b <- 1..n,
        c <- 1..n,
        c >= b,
        b >= a,
        a + b > c,
        a * a + b * b == c * c,
        do: {a, b, c}
  end
end
