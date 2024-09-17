defmodule Fib do
  def naive(1), do: 1
  def naive(2), do: 1

  def naive(n) do
    naive(n - 2) + naive(n - 1)
  end

  def naive(a, b) do
    naive(a + b)
  end

  def faster(n), do: faster(n, 0, 1)
  def faster(1, _acc1, acc2), do: acc2

  def faster(n, acc1, acc2) do
    faster(n - 1, acc2, acc1 + acc2)
  end
end
