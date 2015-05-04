defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir dave@pragprog.com"}]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    issues_url(user, project)
      |> HTTPoison.get(@user_agent)
      |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        { :ok, :jsx.decode(body) }
      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        { :error, :jsx.decode(body) }
      {:error, %HTTPoison.Error{reason: reason}} ->
        { :error, :jsx.decode(reason) }
    end
  end
end
