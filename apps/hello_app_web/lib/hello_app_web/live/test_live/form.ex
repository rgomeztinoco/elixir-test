defmodule HelloAppWeb.TestLive.Form do
  use HelloAppWeb, :live_view

  alias HelloApp.Tests
  alias HelloApp.Tests.Test

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage test records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="test-form" phx-change="validate" phx-submit="save">

        <.input field={@form[:name]} type="text" label="Name" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Test</.button>
          <.button navigate={return_path(@return_to, @test)}>Cancel</.button>
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
    test = Tests.get_test!(id)

    socket
    |> assign(:page_title, "Edit Test")
    |> assign(:test, test)
    |> assign(:form, to_form(Tests.change_test(test)))
  end

  defp apply_action(socket, :new, _params) do
    test = %Test{}

    socket
    |> assign(:page_title, "New Test")
    |> assign(:test, test)
    |> assign(:form, to_form(Tests.change_test(test)))
  end

  @impl true
  def handle_event("validate", %{"test" => test_params}, socket) do
    changeset = Tests.change_test(socket.assigns.test, test_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"test" => test_params}, socket) do
    save_test(socket, socket.assigns.live_action, test_params)
  end

  defp save_test(socket, :edit, test_params) do
    case Tests.update_test(socket.assigns.test, test_params) do
      {:ok, test} ->
        {:noreply,
         socket
         |> put_flash(:info, "Test updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, test))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_test(socket, :new, test_params) do
    case Tests.create_test(test_params) do
      {:ok, test} ->
        {:noreply,
         socket
         |> put_flash(:info, "Test created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, test))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _test), do: ~p"/tests"
  defp return_path("show", test), do: ~p"/tests/#{test}"
end
