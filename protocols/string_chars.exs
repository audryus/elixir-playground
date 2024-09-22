defmodule Employee do
  defstruct name: "", salary: 0

  defimpl String.Chars do
    def to_string(%Employee{name: name, salary: salary}) do
      "Name: #{name} earns #{salary} dollars"
    end
  end
end

defmodule Demo do
  def work do
    %Employee{name: "John", salary: 100_000}
  end
end

Demo.work()
|> IO.puts()
