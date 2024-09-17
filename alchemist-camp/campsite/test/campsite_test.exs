defmodule CampsiteTest do
  use ExUnit.Case
  doctest Campsite

  test "greets the world" do
    assert Campsite.hello() == :world
  end
end
