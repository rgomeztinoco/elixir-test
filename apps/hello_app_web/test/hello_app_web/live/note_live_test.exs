defmodule HelloAppWeb.NoteLiveTest do
  use HelloAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import HelloApp.NotesFixtures

  @create_attrs %{name: "some name", description: "some description"}
  @update_attrs %{name: "some updated name", description: "some updated description"}
  @invalid_attrs %{name: nil, description: nil}
  defp create_note(_) do
    note = note_fixture()

    %{note: note}
  end

  describe "Index" do
    setup [:create_note]

    test "lists all notes", %{conn: conn, note: note} do
      {:ok, _index_live, html} = live(conn, ~p"/notes")

      assert html =~ "Listing Notes"
      assert html =~ note.name
    end

    test "saves new note", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/notes")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Note")
               |> render_click()
               |> follow_redirect(conn, ~p"/notes/new")

      assert render(form_live) =~ "New Note"

      assert form_live
             |> form("#note-form", note: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#note-form", note: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/notes")

      html = render(index_live)
      assert html =~ "Note created successfully"
      assert html =~ "some name"
    end

    test "updates note in listing", %{conn: conn, note: note} do
      {:ok, index_live, _html} = live(conn, ~p"/notes")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#notes-#{note.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/notes/#{note}/edit")

      assert render(form_live) =~ "Edit Note"

      assert form_live
             |> form("#note-form", note: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#note-form", note: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/notes")

      html = render(index_live)
      assert html =~ "Note updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes note in listing", %{conn: conn, note: note} do
      {:ok, index_live, _html} = live(conn, ~p"/notes")

      assert index_live |> element("#notes-#{note.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#notes-#{note.id}")
    end
  end

  describe "Show" do
    setup [:create_note]

    test "displays note", %{conn: conn, note: note} do
      {:ok, _show_live, html} = live(conn, ~p"/notes/#{note}")

      assert html =~ "Show Note"
      assert html =~ note.name
    end

    test "updates note and returns to show", %{conn: conn, note: note} do
      {:ok, show_live, _html} = live(conn, ~p"/notes/#{note}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/notes/#{note}/edit?return_to=show")

      assert render(form_live) =~ "Edit Note"

      assert form_live
             |> form("#note-form", note: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#note-form", note: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/notes/#{note}")

      html = render(show_live)
      assert html =~ "Note updated successfully"
      assert html =~ "some updated name"
    end
  end
end
