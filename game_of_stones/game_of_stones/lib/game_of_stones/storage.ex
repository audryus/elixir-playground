defmodule GameOfStones.Storage do
  use GenServer, restart: :transient

  @server_name :storage
  @ets_name :game_of_stones_storage

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: @server_name)
  end

  def init(_) do
    :ets.new(@ets_name, [:ordered_set, :private, :named_table, {:keypos, 2}])

    {:ok, nil}
  end

  # Interface functions

  def store(data) do
    IO.puts("Storing data ...")
    GenServer.call(@server_name, {:store, data})
  end

  def fetch do
    GenServer.call(@server_name, :fetch)
  end

  def fetch_all do
    GenServer.call(@server_name, :fetch_all)
  end

  # Callbacks
  def handle_call({:store, {:winner, _}}, _, _current_state) do
    IO.puts("Game is over !")
    :ets.delete_all_objects(@ets_name)

    {:reply, nil, nil}
  end

  def handle_call({:store, data}, _, _current_state) do
    :ets.insert(@ets_name, data)
    {:reply, data, data}
  end

  def handle_call(:fetch_all, _, current_state) do
    {:reply, :ets.tab2list(@ets_name), current_state}
  end

  def handle_call(:fetch, _, current_state) do
    {:reply, current_state, current_state}
  end
end
