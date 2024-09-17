defmodule Greeter do
  @author "Mark"
  def start do
    name = IO.gets("What is your name?\n") |> String.trim()

    case name do
      @author -> "Wow ! #{@author} is my favorite name too !"
      name -> "Hi, #{name}. It's nice to meet you."
    end
  end
end
