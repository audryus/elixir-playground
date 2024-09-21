defmodule Demo do
  use GenServer

  def start(initial_state) do
    GenServer.start(__MODULE__, initial_state, name: __MODULE__)
  end

  def exponential() do
    GenServer.cast(__MODULE__, :exp)
  end

  def sqrt(pid) do
    GenServer.cast(pid, :sqrt)
  end

  def add(pid, number) do
    GenServer.cast(pid, {:add, number})
  end

  def result(pid) do
    # timeout is 5 seconds
    GenServer.call(pid, :result)
  end

  # Sync request
  def handle_call(:result, _, current_state) do
    # :timer.sleep(6000)
    {:reply, current_state, current_state}
  end

  def terminate(reason, current_state) do
    reason |> IO.inspect()
    current_state |> IO.inspect()
  end

  # Assync request
  def handle_cast(:exp, current_state) do
    {:noreply, current_state * current_state}
  end

  def handle_cast(:sqrt, current_state) do
    {:noreply, :math.sqrt(current_state)}
  end

  def handle_cast({:add, number}, current_state) when is_number(number) do
    {:noreply, current_state + number}
  end

  def handle_cast({:add, _}, current_state) do
    {:stop, "not a number", current_state}
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
{:ok, pid} = Demo.start(4)
Demo.sqrt(pid) |> IO.inspect()
Demo.add(pid, 10) |> IO.inspect()
Demo.result(pid) |> IO.inspect()
Demo.exponential() |> IO.inspect()
Demo.result(pid) |> IO.inspect()
