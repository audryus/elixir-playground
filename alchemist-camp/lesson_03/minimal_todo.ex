defmodule MinimalTodo do
  def start do
    input = IO.gets("Would you like to create a new .csv ? (y/n) \n")
    |> String.trim()
    |> String.downcase()

    if input == "y" do
      create_initial_todo() |> get_command
    else
      load_csv()
    end
  end

  def add_todo(data) do
    name = get_item_name(data)
    titles = get_fields(data)
    fields = Enum.map(titles, fn field -> field_from_user(field) end)
    new_todo = %{name => Enum.into(fields, %{})}
    IO.puts(~s(New TODO "#{name}" added.\n))
    new_data = Map.merge(data, new_todo)

    get_command(new_data)
  end

  def create_header(headers) do
    case IO.gets("Add field: ") |> String.trim do
      "" -> headers
      header -> create_header([header | headers])
    end
  end

  def create_headers() do
    IO.puts """
    What data should each TODO have ?
    Enter field names one by one and an empty line when you're done.
    """
    create_header([])
  end

  def create_initial_todo() do
    titles = create_headers()
    name = get_item_name(%{})
    fields = Enum.map(titles, &(field_from_user(&1)))
    IO.puts(~s(New TODO "#{name}" added.\n))
    %{name => Enum.into(fields, %{})}
  end

  def field_from_user(name) do
    field = IO.gets("#{name}: ") |> String.trim
    case field do
      _ -> {name, field}
    end
  end

  def get_command(data) do
    prompt = """
    Type the first letter of the command you want to run
    R)ead Todos
    A)dd a Todo
    D)elete a Todo
    L)oad a .csv
    S)ave a .csv
    Q)uit
    """

    command =
      IO.gets(prompt)
      |> String.trim()
      |> String.downcase()

    case command do
      "r" -> show_todos(data)
      "a" -> add_todo(data)
      "d" -> delete_todo(data)
      "l" -> load_csv()
      "s" -> save_csv(data)
      "q" -> "Goodbye!"
      _ -> get_command(data)
    end
  end

  def get_fields(data) do
    data[hd Map.keys data] |> Map.keys
  end

  def get_item_name(data) do
    name = IO.gets("Enter the name of the new todo: ") |> String.trim
    if Map.has_key?(data, name) do
      IO.puts("Todo with that name already exists!\n")
      get_item_name(data)
    else
      name
    end
  end

  def delete_todo(data) do
    todo =
      IO.gets("Which todo would you like to delete? ")
      |> String.trim()

    if Map.has_key?(data, todo) do
      IO.puts("ok.")
      new_data = Map.drop(data, [todo])
      IO.puts(~s{"#{todo}" has been deleted.\n})
      get_command(new_data)
    else
      IO.puts(~s{There is no Todo named "#{todo}" !\n})
      show_todos(data, false)
      delete_todo(data)
    end
  end

  def load_csv() do
    filename = IO.gets("Name of .csv to load: ") |> String.trim()

    read(filename)
    |> parse
    |> get_command
  end

  def read(filename) do
    case File.read(filename) do
      {:ok, body} ->
        body

      {:error, reason} ->
        IO.puts(~s(Could not open file "#{filename}"\n))
        IO.puts(~s("#{:file.format_error(reason)}"\n))
        start()
    end
  end

  def parse(body) do
    [header | lines] = String.split(body, ~r{(\r\n|\r|\n)})
    titles = tl(header |> String.split(","))
    parse_lines(lines, titles)
  end

  def parse_lines(lines, titles) do
    Enum.reduce(lines, %{}, fn line, built ->
      [name | fields] = String.split(line, ",")

      if Enum.count(fields) == Enum.count(titles) do
        line_data = Enum.zip(titles, fields) |> Enum.into(%{})
        Map.merge(built, %{name => line_data})
      else
        built
      end
    end)
  end

  def prepare_csv(data) do
    headers =["Item" | get_fields(data)]
    items = Map.keys(data)
    item_rows = Enum.map(items, fn item ->
      [item | Map.values(data[item])]
    end)
    rows = [headers | item_rows]
    row_strings = Enum.map(rows, &(Enum.join(&1, ",")))
    Enum.join(row_strings, "\n")
  end

  def save_csv(data) do
    filename = IO.gets("Name of .csv to save: ") |> String.trim()
    filedata = prepare_csv(data)
    case File.write(filename, filedata) do
      :ok -> IO.puts("CSV saved")
      {:error, reason} -> IO.puts(~s(Could not save file "#{filename}"\n))
                          IO.puts(~s("#{:file.format_error(reason)}"\n))
                          get_command(data)
    end
  end

  def show_todos(data, next_command? \\ true) do
    items = Map.keys(data)
    IO.puts("You have the following Todos: \n")
    Enum.each(items, fn item -> IO.puts(item) end)
    IO.puts("\n")

    if next_command? do
      get_command(data)
    end
  end
end
