filename =
  IO.gets("File to count the word from (h for help): \n")
  |> String.trim()

if filename == "h" do
  IO.puts("""
  Usage: [filename] -[flags]
  Flags:
  -l   Display line count
  -c   Display character count
  -w   Display word count (default)
  Multiple flags may be used. Example usage to display line and character counts:

  somefile.txt -lc

  """)
else
  parts = String.split(filename, "-")
  filename = List.first(parts) |> String.trim()

  flags =
    case Enum.at(parts, 1) do
      nil -> ["w"]
      chars -> chars |> String.split("") |> Enum.filter(fn x -> x != "" end)
    end

  body = File.read!(filename)
  lines = body |> String.split(~r{(\r\n|\r|\n)})

  words =
    body
    |> String.split(~r{(\\n|[^\w'])+})
    |> Enum.filter(fn x -> x != "" end)

  chars = body |> String.split("") |> Enum.filter(fn x -> x != "" end)

  Enum.each(flags, fn flag ->
    case flag do
      "l" -> IO.puts("Lines: #{Enum.count(lines)}")
      "w" -> IO.puts("Words: #{Enum.count(words)}")
      "c" -> IO.puts("Chars: #{Enum.count(chars)}")
      _ -> nil
    end
  end)
end
