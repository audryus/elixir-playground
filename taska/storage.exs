defmodule Storage do
  @name {:global, :storage}

  def start_link do
    Agent.start_link(fn -> %{} end, name: @name)
  end

  def store(result, number) do
    Agent.update(@name, fn state -> Map.merge(state, %{number => result}) end)
  end

  def factorials do
    Agent.get(@name, & &1)
  end

  def factorial_of(number) do
    Map.get(factorials(), number)
  end
end

defmodule FactorialProducer do
  # enum
  def product_of(numbers) do
    numbers
    |> Stream.map(fn number -> Task.async(fn -> fact(number) end) end)
    |> Enum.map(&Task.await/1)
  end

  def fact(number) do
    do_fact(1, number)
    |> Storage.store(number)
  end

  defp do_fact(result, 0), do: result

  defp do_fact(result, a) do
    (result * a)
    |> do_fact(a - 1)
  end
end

# Storage.start_link()
# FactorialProducer.product_of(1..10)
# Storage.factorials() |> IO.inspect()
# Storage.factorial_of(10) |> IO.inspect()

# iex -- sname(node1(storage.exs))
# iex -- sname(node2(storage.exs))
# Node.connect :"node1@DESKTOP-2E7F0S0"

# node 1
# Storage.start_link()
# FactorialProducer.product_of(1..10)

# node 2
# FactorialProducer.product_of(11..20)

# both nodes
# Storage.factorials()
