defmodule HelloAppWeb.TestLive.Show do
  use HelloAppWeb, :live_view

  alias HelloApp.Tests

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Test {@test.id}
        <:subtitle>This is a test record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/tests"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/tests/#{@test}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit test
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Results">{@test.results}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Test")
     |> assign(:test, Tests.get_test!(id))}
  end
end
