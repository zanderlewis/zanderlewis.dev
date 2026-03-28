defmodule Website.Home do
  @moduledoc """
  Helper for the home route.

  `context/0` returns a `{template_path, assigns}` tuple suitable for rendering
  the home page. The assigns are returned as a keyword list to match the
  rendering function's expected argument type.
  """

  @spec context() :: {String.t(), Keyword.t()}
  def context do
    # Birthdate (YYYY-MM-DD)
    dob = ~D[2008-09-14]
    today = Date.utc_today()

    years = today.year - dob.year

    birthday_this_year =
      case Date.new(today.year, dob.month, dob.day) do
        {:ok, d} -> d
        {:error, _} -> Date.new!(today.year, 2, 28)
      end

    age = if Date.compare(today, birthday_this_year) == :lt, do: years - 1, else: years

    tpl =
      Path.expand(Path.join([__DIR__, "..", "templates", "index.html.eex"]))

    layout =
      Path.expand(Path.join([__DIR__, "..", "templates", "layout.html.eex"]))

    assigns = [
      layout: layout,
      title: "Home",
      ver: Mflask.mflask_version(),
      age: age
    ]

    {tpl, assigns}
  end
end
