defmodule TodoAppWeb.PageLiveTest do
  use TodoAppWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "What needs to be done?"
    assert render(page_live) =~ "What needs to be done?"
  end
end
