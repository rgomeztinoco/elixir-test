defmodule RankTrackerWeb.NoteLive.Index do
  use RankTrackerWeb, :live_view

  alias RankTracker.Notes

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Notes
        <:actions>
          <.button variant="primary" navigate={~p"/notes/new"}>
            <.icon name="hero-plus" /> New Note
          </.button>
        </:actions>
      </.header>

      <.table
        id="notes"
        rows={@streams.notes}
        row_click={fn {_id, note} -> JS.navigate(~p"/notes/#{note}") end}
      >
        <:col :let={{_id, note}} label="Name">{note.name}</:col>
        <:col :let={{_id, note}} label="Description">{note.description}</:col>
        <:action :let={{_id, note}}>
          <div class="sr-only">
            <.link navigate={~p"/notes/#{note}"}>Show</.link>
          </div>
          <.link navigate={~p"/notes/#{note}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, note}}>
          <.link
            phx-click={JS.push("delete", value: %{id: note.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Notes")
     |> stream(:notes, list_notes())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    note = Notes.get_note!(id)
    {:ok, _} = Notes.delete_note(note)

    {:noreply, stream_delete(socket, :notes, note)}
  end

  defp list_notes() do
    Notes.list_notes()
  end
end
