defmodule Demo do
  defmacro work_bind(time) do
    quote bind_quoted: [time: time] do
      time |> IO.inspect()
      :timer.sleep(1000)
      time |> IO.inspect()
    end
  end

  defmacro work(time) do
    another_var = "Outside macro"

    quoted_code =
      quote do
        another_var = "Inside macro"

        unquote(time) |> IO.inspect()
        :timer.sleep(1000)
        unquote(time) |> IO.inspect()

        another_var |> IO.inspect()
      end

    quoted_code
    |> Macro.to_string()
    |> IO.inspect()

    another_var |> IO.inspect()

    quoted_code
  end
end

defmodule Playground do
  require Demo

  def test! do
    another_var = "Inside test!"
    IO.puts("binding")
    :os.system_time() |> Demo.work_bind()
    IO.puts("Not bind")
    :os.system_time() |> Demo.work()

    another_var |> IO.inspect()
  end
end

Playground.test!()
