defmodule Company do
  defstruct title: "", emplyees: []

  defimpl Enumerable do
    def reduce(_, {:halt, acc}, _fun), do: {:halted, acc}

    def reduce(company, {:suspend, acc}, fun) do
      {:suspended, acc, &reduce(company, &1, fun)}
    end

    def reduce(%Company{emplyees: []}, {:cont, acc}, _fun) do
      {:done, acc}
    end

    def reduce(%Company{emplyees: [head | tail]}, {:cont, acc}, fun) do
      reduce(%Company{emplyees: tail}, fun.(head, acc), fun)
    end

    def count(%Company{emplyees: emplyees}) do
      {:ok, Enum.count(emplyees)}
    end

    def member?(%Company{emplyees: emplyees}, employee) do
      {:ok, Enum.member?(emplyees, employee)}
    end
  end
end

defmodule Employee do
  defstruct name: "", salary: "", works_for: 0

  defimpl String.Chars do
    def to_string(%Employee{name: name, salary: salary}) do
      "Name: #{name} earns #{salary} dollars"
    end
  end
end

defmodule Demo do
  def work do
    company = %Company{
      title: "CC LLC",
      emplyees: [
        %Employee{name: "John", salary: "food", works_for: 2},
        %Employee{name: "Jane", salary: "very high", works_for: 100},
        %Employee{name: "Doe", salary: "who knows", works_for: 9000}
      ]
    }

    Enum.count(company) |> IO.inspect()

    Enum.member?(company, %Employee{name: "John", salary: "food", works_for: 2})
    |> IO.inspect()

    Enum.reduce(company, 0, fn employee, total_years -> employee.works_for + total_years end)
    |> IO.inspect()
  end
end

Demo.work()
