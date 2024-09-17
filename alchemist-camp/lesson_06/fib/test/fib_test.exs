defmodule FibTest do
  use ExUnit.Case
  doctest Fib

  test "naive fibonacci base cases" do
    assert Fib.naive(1) == 1
    assert Fib.naive(2) == 1
  end

  test "naive fibonacci other numbers" do
    assert Fib.naive(6) == 8
    assert Fib.naive(9) == 34
    assert Fib.naive(17) == 1597
  end

  test "faster fibonacci base cases" do
    assert Fib.faster(1) == 1
    assert Fib.faster(2) == 1
  end

  test "faster fibonacci other numbers" do
    assert Fib.faster(6) == 8
    assert Fib.faster(9) == 34
    assert Fib.faster(17) == 1597
  end

  test "faster fibonacci really large number" do
    assert Fib.faster(150) == 9_969_216_677_189_303_386_214_405_760_200
  end
end
