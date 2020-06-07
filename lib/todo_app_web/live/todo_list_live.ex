defmodule TodoAppWeb.TodoListLive do
  use TodoAppWeb, :live_view

  alias TodoApp.Todo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, todos: [], filter: "all")}
  end

  @impl true
  def handle_params(%{"filter" => filter}, _uri, socket) do
    {:noreply, assign(socket, filter: filter)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("add-todo", %{"text" => ""}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("add-todo", %{"text" => text}, socket) do
    todos = socket.assigns[:todos] ++ [Todo.new(text)] |> IO.inspect
    {:noreply, assign(socket, todos: todos)}
  end

  @impl true
  def handle_event("edit", %{"todo-id" => id}, socket) do
    toggle_editing = fn
      %Todo{id: ^id} = todo -> %{todo | editing: true}
      todo -> todo
    end
    todos = socket.assigns[:todos] |> Enum.map(toggle_editing) |> IO.inspect
    {:noreply, assign(socket, todos: todos)}
  end

  @impl true
  def handle_event("change", %{"title" => text}, socket) do
    update_text = fn
      %Todo{editing: true} = todo -> %{todo | text: text} |> IO.inspect
      todo -> todo
    end
    todos = socket.assigns[:todos] |> Enum.map(update_text) |> IO.inspect
    {:noreply, assign(socket, todos: todos)}
  end

  def handle_event("stop-editing", %{"todo-id" => id}, socket) do
    toggle_editing = fn
      %Todo{id: ^id} = todo -> %{todo | editing: false}
      todo -> todo
    end
    todos = socket.assigns[:todos]
            |> Enum.map(toggle_editing)
    {:noreply, assign(socket, todos: todos)}
  end

  @impl true
  def handle_event("delete-todo", %{"todo-id" => id}, socket) do
    todos = socket.assigns[:todos]
            |> Enum.filter(&(&1.id !== id))
    {:noreply, assign(socket, todos: todos)}
  end

  @impl true
  def handle_event("toggle", %{"todo-id" => id}, socket) do
    toggle = fn
      %Todo{id: ^id} = todo -> Todo.toggle(todo)
      todo -> todo
    end
    todos = socket.assigns[:todos]
            |> Enum.map(toggle)
    {:noreply, assign(socket, todos: todos)}
  end

  @impl true
  def handle_event("toggle-all", %{"checked" => "false"}, socket) do
    todos = socket.assigns[:todos]
            |> Enum.map(&Todo.complete/1)
    {:noreply, assign(socket, todos: todos)}
  end

  @impl true
  def handle_event("toggle-all", _params, socket) do
    todos = socket.assigns[:todos]
            |> Enum.map(&Todo.activate/1)
    {:noreply, assign(socket, todos: todos)}
  end

  def todo_classes(todo) do
    [
      if(todo.editing, do: "editing"),
      if(todo.state == "completed", do: "completed")
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
  end

  def all_todos_completed?(todos) do
    !Enum.any?(todos, fn t -> t.state == "active" end)
  end

  def todos_count_text(todos) do
    remaining = Enum.filter(todos, fn t -> t.state == "active" end)
                |> Enum.count
    to_string(remaining) <> " items " <> "left"
  end

  def selected_class(filter, filter), do: "selected"
  def selected_class(_current_filter, _new_filter), do: ""

  def todo_visible?(_todo, "all"), do: true
  def todo_visible?(%{state: state}, state), do: true
  def todo_visible?(_, _), do: false
end