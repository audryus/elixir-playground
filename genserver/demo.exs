defmodule Demo do
  use GenServer

  def start(initial_state) do
    GenServer.start(__MODULE__, initial_state)
  end

  # Callback is run when the server is started
  def init(initial_state) when is_number(initial_state) do
    "I am starte with stat #{initial_state}" |> IO.puts()
    {:ok, initial_state}
  end

  def init(_) do
    {:stop, "The initial state is not a number !"}
  end
end

# GenServer.start(Demo, 0) |> IO.inspect()
# GenServer.start(Demo, "0") |> IO.inspect()
Demo.start(0) |> IO.inspect()
