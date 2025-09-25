defmodule HelloAppWeb.NoteLive.Show do
  use HelloAppWeb, :live_view

  alias HelloApp.Notes

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Note {@note.id}
        <:subtitle>This is a note record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/notes"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/notes/#{@note}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit note
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@note.name}</:item>
        <:item title="Description">{@note.description}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Note")
     |> assign(:note, Notes.get_note!(id))}
  end
end
