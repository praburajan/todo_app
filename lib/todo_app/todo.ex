defmodule TodoApp.Todo do
  @moduledoc """
  This module holds the list of todos
"""
  alias __MODULE__

  @enforce_keys [:id, :text, :state]
  # define the module struct with the following keys
  defstruct [:id, :text, :state, :editing]

  def new(text) do
    # This is like a static function that creates a new struct of this module and returns
    # the same
    %Todo{id: UUID.uuid4(), text: text, state: "active", editing: false}
  end

  def complete(todo) do
    %{todo | state: "completed"}
  end

  def activate(todo) do
    %{todo | state: "active"}
  end

  def toggle(%Todo {state: "active"} = todo) do
    complete(todo)
  end

  def toggle(%Todo {state: "completed"} = todo) do
    activate(todo)
  end
end