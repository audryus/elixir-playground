defmodule Campsite.Web.Router do
  import Glue.Conn

  @template_path "lib/campsite/web/templates"

  @spec call(Glue.Conn) :: Glue.Conn
  def call(conn) do
    content_for(conn.req_path, conn)
  end

  defp content_for("/", conn) do
    conn
    |> put_resp_body("""
      <h1>Welcome to Alchemist Camp! ! !</h1>
    """)
  end

  defp content_for("/too", conn) do
    conn
    |> put_resp_body("""
      <h1>Welcome to Alchemist Camp, here too !</h1>
    """)
  end

  defp content_for("/contact", conn) do
    conn
    |> put_resp_body("""
      <h1>you can find us on twitter!</h1>
    """)
  end

  defp content_for("/secret", conn) do
    conn
    |> put_resp_body("""
      <h1>this is a secret page!</h1>
    """)
  end

  defp content_for("/hello", conn) do
    conn
    |> assign(:adj, "mysterions")
    |> assign(:val, 3)
    |> render("hello")
  end

  defp content_for(other, conn) do
    name = Path.basename(other)

    if Enum.member?(get_templates(), name) do
      render(conn, name)
    else
      not_found(conn, name)
    end
  end

  defp not_found(conn, route) do
    conn
    |> put_status(404)
    |> put_resp_body("""
      <h1>not found ! #{route}</h1>
    """)
  end

  defp render(conn, name) do
    case eval_file(name, Enum.to_list(conn.assigns)) do
      {:ok, body} ->
        conn
        |> put_resp_body(body)

      {:error, details} ->
        conn
        |> put_status(500)
        |> put_resp_body("<h1>Template Compile Error</h1>#{details}")
    end
  end

  defp eval_file(name, assigns) do
    try do
      {:ok, EEx.eval_file("#{@template_path}/#{name}.eex", assigns)}
    rescue
      e in CompileError ->
        details =
          Enum.reduce(Map.from_struct(e), "", fn {k, v}, acc ->
            acc <> "<strong>#{k}:</strong> #{v}<br>"
          end)

        {:error, details}
    end
  end

  defp get_templates() do
    for t <- Path.wildcard("#{@template_path}/*.eex"),
        do: Path.basename(t, ".eex")
  end
end
