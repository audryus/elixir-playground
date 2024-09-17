defmodule Campsite.Web.PageHandler do
  @type request :: any()
  @type response :: any()

  @doc """
  Receives request and Campsite.Web.Router
  """
  @doc since: "1.0"
  @spec init(request, Campsite.Web.Router) :: {atom(), response, Campsite.Web.Router}
  def init(req, router) do
    handle(req, router)
  end

  defp handle(request, router) do
    path = :cowboy_req.path(request)
    conn = %Glue.Conn{req_path: path}
    conn = router.call(conn)

    res =
      :cowboy_req.reply(
        # status code
        conn.status,

        # headers
        conn.resp_header,

        # body of reply.
        conn.resp_body,

        # original request
        request
      )

    {:ok, res, router}
  end

  def terminate(_reason, _request, _state) do
    # IO.puts("Terminating for reason: #{inspect(reason)}")
    # IO.puts("Terminating after request: #{inspect(request)}")
    # IO.puts("Terminating with state: #{inspect(state)}")

    :ok
  end
end
