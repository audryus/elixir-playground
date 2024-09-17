matcher = ~r/\.(jpeg|jpg|gif|png)$/
matched_file = File.ls!(".") |> Enum.filter(&Regex.match?(matcher, &1))

num_matched = Enum.count(matched_file)

msg_end =
  case num_matched do
    1 -> "file"
    _ -> "files"
  end

IO.puts("Found #{num_matched} #{msg_end}.")

case File.mkdir("./images") do
  :ok -> IO.puts("./images directory created")
  {:error, _} -> IO.puts("Could not create ./images directory")
end

Enum.each(matched_file, fn filename ->
  case File.rename(filename, "./images/#{filename}") do
    :ok -> IO.puts("#{filename} moved to images directory.")
    {:error, _} -> IO.puts("Error moving #{filename} to images directory.")
  end
end)
