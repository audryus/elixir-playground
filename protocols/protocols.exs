defprotocol DemoProtocol do
  @fallback_to_any true
  def work(arg)
end

defimpl DemoProtocol, for: Any do
  def work(arg) do
    IO.puts("Some imple !")
  end
end

# defimpl Enumberable, for: Integer do
#  def count(_) do
#    1
#  end
# end

DemoProtocol.work(42)
DemoProtocol.work([1, 2, 3])
# Enumberable.count(42) |> IO.puts()
