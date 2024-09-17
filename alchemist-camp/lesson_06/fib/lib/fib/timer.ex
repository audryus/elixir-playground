defmodule Fib.Timer do
  def time(func, arglist) do
    t0 = Time.utc_now()
    apply(func, arglist)
    Time.diff(Time.utc_now(), t0, :millisecond)
  end
end
