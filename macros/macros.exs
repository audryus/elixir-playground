defmodule Demo do
  defmacro work(arg) do
    # arg
    quote do
      # {1, 2, 3, 4, 5}
      # not work: arg * 10
      unquote(arg) * 10
    end
  end

  defmacro macro_palindrome?(str, expr) do
    quote do
      if(unquote(str) == String.reverse(unquote(str))) do
        unquote(expr)
      end
    end
  end

  def palindrome?(str, expr) do
    if str == String.reverse(str), do: expr
  end
end

defmodule Playground do
  require Demo

  def test! do
    # Demo.work({1, 2, 3, 4, 5})
    # Demo.work(2)
    # Demo.macro_palindrome?("adsfadas", IO.puts("found one!"))
    Demo.macro_palindrome?("123321", IO.puts("found one!"))
    # |> elem(2)
    |> IO.inspect()
  end
end

Playground.test!()
