defmodule WordCount do
  def start(parsed, file, invalid) do
    if invalid != [] or file == "h" do
      show_help()
    else
      read_file(parsed, file)
    end
  end

  def show_help() do
    IO.puts("""
    Usage: [filename] -[flags]
    Flags:
    -l   Display line count
    -c   Display character count
    -w   Display word count (default)
    Multiple flags may be used. Example usage to display line and character counts:

    somefile.txt -lc

    """)
  end

  def read_file(parsed, filename) do
    flags =
      case Enum.count(parsed) do
        0 -> [:words]
        _ -> Enum.map(parsed, &elem(&1, 0))
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
        :lines -> IO.puts("Lines: #{Enum.count(lines)}")
        :words -> IO.puts("Words: #{Enum.count(words)}")
        :chars -> IO.puts("Chars: #{Enum.count(chars)}")
        _ -> nil
      end
    end)
  end
end
