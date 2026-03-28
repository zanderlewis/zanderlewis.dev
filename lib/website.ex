defmodule Website do
  use Mflask

  Mflask.Router.plug(Mflask.Middleware.Logger)

  Mflask.Router.plug(Mflask.Middleware.Static,
    at: "/static",
    from: Path.join(__DIR__, "priv/static")
  )

  Mflask.Router.plug(Mflask.Middleware.BodyParser)

  defp get_base_and_page_url(conn) do
    scheme = to_string(conn.scheme)
    host = conn.host
    port = conn.port

    port_part =
      case {scheme, port} do
        {"http", 80} -> ""
        {"https", 443} -> ""
        _ -> ":" <> Integer.to_string(port)
      end

    base_url = scheme <> "://" <> host <> port_part
    page_url = base_url <> conn.request_path

    {base_url, page_url}
  end

  get "/" do
    {base_url, page_url} = get_base_and_page_url(conn)
    {tpl, assigns} = Website.Home.context()
    assigns = Keyword.merge(assigns, base_url: base_url, page_url: page_url)

    render(conn, tpl, assigns)
  end

  get "/portfolio" do
    {base_url, page_url} = get_base_and_page_url(conn)
    {tpl, assigns} = Website.Portfolio.context()
    assigns = Keyword.merge(assigns, base_url: base_url, page_url: page_url)

    render(conn, tpl, assigns)
  end

  get "/resume" do
    {base_url, page_url} = get_base_and_page_url(conn)
    {tpl, assigns} = Website.Resume.context()
    assigns = Keyword.merge(assigns, base_url: base_url, page_url: page_url)

    render(conn, tpl, assigns)
  end
end
