defmodule HelloAppWeb.PageController do
  use HelloAppWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
