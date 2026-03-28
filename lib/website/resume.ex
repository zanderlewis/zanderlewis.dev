defmodule Website.Resume do
  @moduledoc """
  Provides the template path and assigns for the resume route.

  `context/0` returns a `{template_path, assigns}` tuple so the router can
  render the page with minimal logic. This keeps route code concise and
  makes the data easy to test independently.
  """

  @spec context() :: {String.t(), Keyword.t()}
  def context do
    tpl =
      Path.expand(Path.join([__DIR__, "..", "templates", "resume.html.eex"]))

    layout =
      Path.expand(Path.join([__DIR__, "..", "templates", "layout.html.eex"]))

    experience = [
      %{
        company: "Thai Chili Asian Bistro",
        position: "Server",
        description: "Server for ~2.5 years"
      },
      %{
        company: "Griff's Kitchen & Bar",
        position: "Server",
        description: "Server for ~6 months"
      }
    ]

    skills = [
      "PHP/Laravel",
      "Python",
      "Git",
      "Linux"
    ]

    education = [
      %{
        institution: "CS50x (Harvard University)",
        degree: "Certificate of Completion",
        graduation_year: 2023
      },
      %{
        institution: "Franklin School of Innovation (High School)",
        degree: "High School Diploma",
        # Expected graduation year
        graduation_year: 2027
      }
    ]

    assigns = [
      layout: layout,
      title: "Resume",
      experience: experience,
      skills: skills,
      education: education
    ]

    {tpl, assigns}
  end
end
