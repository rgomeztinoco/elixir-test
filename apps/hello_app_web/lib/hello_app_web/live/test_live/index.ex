defmodule HelloAppWeb.TestLive.Index do
  use HelloAppWeb, :live_view

  alias HelloApp.Tests

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Tests
        <:actions>
          <.button variant="primary" navigate={~p"/tests/new"}>
            <.icon name="hero-plus" /> New Test
          </.button>
        </:actions>
      </.header>

      <.table
        id="tests"
        rows={@streams.tests}
        row_click={fn {_id, test} -> JS.navigate(~p"/tests/#{test}") end}
      >
        <:col :let={{_id, test}} label="Results">{test.results}</:col>
        <:action :let={{_id, test}}>
          <div class="sr-only">
            <.link navigate={~p"/tests/#{test}"}>Show</.link>
          </div>
          <.link navigate={~p"/tests/#{test}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, test}}>
          <.link
            phx-click={JS.push("delete", value: %{id: test.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Tests")
     |> stream(:tests, list_tests())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    test = Tests.get_test!(id)
    {:ok, _} = Tests.delete_test(test)

    {:noreply, stream_delete(socket, :tests, test)}
  end

  defp list_tests() do
    Tests.list_tests()
  end
end
