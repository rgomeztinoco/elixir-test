defmodule HelloAppWeb.NoteLive.Form do
  use HelloAppWeb, :live_view

  alias HelloApp.Notes
  alias HelloApp.Notes.Note

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage note records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="note-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Note</.button>
          <.button navigate={return_path(@return_to, @note)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    note = Notes.get_note!(id)

    socket
    |> assign(:page_title, "Edit Note")
    |> assign(:note, note)
    |> assign(:form, to_form(Notes.change_note(note)))
  end

  defp apply_action(socket, :new, _params) do
    note = %Note{}

    socket
    |> assign(:page_title, "New Note")
    |> assign(:note, note)
    |> assign(:form, to_form(Notes.change_note(note)))
  end

  @impl true
  def handle_event("validate", %{"note" => note_params}, socket) do
    changeset = Notes.change_note(socket.assigns.note, note_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"note" => note_params}, socket) do
    save_note(socket, socket.assigns.live_action, note_params)
  end

  defp save_note(socket, :edit, note_params) do
    case Notes.update_note(socket.assigns.note, note_params) do
      {:ok, note} ->
        {:noreply,
         socket
         |> put_flash(:info, "Note updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, note))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_note(socket, :new, note_params) do
    case Notes.create_note(note_params) do
      {:ok, note} ->
        {:noreply,
         socket
         |> put_flash(:info, "Note created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, note))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _note), do: ~p"/notes"
  defp return_path("show", note), do: ~p"/notes/#{note}"
end
