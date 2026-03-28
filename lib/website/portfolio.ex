defmodule Website.Portfolio do
  @moduledoc """
  Provides the template path and assigns for the portfolio route.

  `context/0` returns `{template_path, assigns}` to keep the router simple
  and make the route logic easy to test.
  """

  @spec context() :: {String.t(), Keyword.t()}
  def context do
    tpl =
      Path.expand(Path.join([__DIR__, "..", "templates", "portfolio.html.eex"]))

    layout =
      Path.expand(Path.join([__DIR__, "..", "templates", "layout.html.eex"]))

    projects = [
      %{
        name: "Master Flask",
        description:
          "A Flask-like web framework built in Elixir. This website is built with Master Flask.",
        link: "https://hex.pm/packages/mflask",
        repository: "https://codeberg.org/zanderlewis/mflask"
      },
      %{
        name: "Grey Linux",
        description: "A Linux distribution created from scratch for boot.hackclub.com.",
        repository: "https://codeberg.org/zanderlewis/greylinux/"
      }
    ]

    assigns = [
      layout: layout,
      title: "Portfolio",
      projects: projects
    ]

    {tpl, assigns}
  end
end
