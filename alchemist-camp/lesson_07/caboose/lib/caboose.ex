defmodule Caboose do
  @default_lines 10

  def start(parsed, filename, invalid) do
    help_flag = Enum.member?(parsed, {:help, true})

    if Enum.count(filename) != 1 or invalid != [] or help_flag do
      unless help_flag, do: IO.puts("Bad input\n")
      show_help()
    else
      flags = Enum.into(parsed, %{})
      read_file(filename, flags)
    end
  end

  def show_help() do
    IO.puts("""
    Usage: caboose [filename] -[flags] [flag args]

    Flags:
    --help             Show this help
    --lines [number]   Display number of lines (default: #{@default_lines})
    -h                 Same as --help
    -n [number]        Same as --lines

    Example usage:
    caboose somefile.txt
    caboose somefile.txt --lines 40

    """)
  end

  def read_file(filename, flags) do
    body = File.read!(filename)
    lines = body |> String.split(~r{(\r\n|\r|\n)})

    num_displayed = if flags[:lines], do: flags[:lines], else: @default_lines

    lines
    |> Enum.take(-num_displayed)
    |> Enum.join("\n")
    |> IO.puts()
  end
end
