defmodule SendupTest do
  use ExUnit.Case
  doctest Sendup

  test "greets the world" do
    assert Sendup.hello() == :world
  end
end
