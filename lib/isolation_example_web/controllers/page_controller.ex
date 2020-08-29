defmodule IsolationExampleWeb.PageController do
  use IsolationExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
