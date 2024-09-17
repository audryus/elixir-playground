defmodule AlchemyMarkdownTest do
  use ExUnit.Case
  doctest AlchemyMarkdown

  test "italic" do
    str = "Something *important*"
    assert AlchemyMarkdown.to_html(str) =~ "<em>important</em>"
  end

  test "expands big tags" do
    str = "Some ++big++ words !"
    assert AlchemyMarkdown.to_html(str) =~ "<big>big</big> words"
  end

  test "expands small tags" do
    str = "Some --small-- words !"
    assert AlchemyMarkdown.to_html(str) =~ "<small>small</small> words"
  end

  test "expands hr tags" do
    str1 = "Stuff over the line\n---"
    str2 = "Stuff over the line\n***"
    str3 = "Stuff over the line\n- - -"
    str4 = "Stuff over the line\n*  *  *"
    str5 = "Stuff over the line*  *  *"

    Enum.each(
      [str1, str2, str3, str4],
      &assert(
        AlchemyMarkdown.hrs(&1) ==
          "Stuff over the line\n<hr />"
      )
    )

    assert AlchemyMarkdown.hrs(str5) == str5
  end
end
