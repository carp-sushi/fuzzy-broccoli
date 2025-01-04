# .iex.exs
# Configure IEx project settings

# Common imports used frequently
import Enum, only: [map: 2, reduce: 3, filter: 2]
import String, only: [upcase: 1, downcase: 1]

# Project imports for ad-hoc testing
alias Todos.Repo
alias Todos.Data.Repo.{StoryRepo, TaskRepo}
alias Todos.Data.Schema.{Story, Task}
alias Todos.UseCase.Story.{CreateStory, DeleteStory, GetStory, ListStories, UpdateStory}
alias Todos.UseCase.Task.{CreateTask, DeleteTask, GetTask, ListTasks, UpdateTask}

# Test accounts
alice = "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska"
bob = "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskb"

# Configure shell appearance
Application.put_env(:elixir, :ansi_enabled, true)

IEx.configure(
  history_size: 100,
  inspect: [
    limit: 5_000,
    pretty: true,
    width: 80
  ],
  colors: [
    syntax_colors: [
      number: :blue,
      atom: :cyan,
      string: :green,
      boolean: :red,
      nil: :red
    ],
    eval_result: [:green, :bright],
    eval_error: [:red, :bright],
    eval_info: [:blue, :bright]
  ],
  default_prompt:
    "#{IO.ANSI.green()}%prefix#{IO.ANSI.reset()}" <>
      "(#{IO.ANSI.cyan()}%counter#{IO.ANSI.reset()}) >"
)

# Helper functions
defmodule IExHelpers do
  def reload! do
    Mix.Task.reenable("compile.elixir")
    Application.stop(Mix.Project.config()[:app])
    Mix.Task.run("compile.elixir")
    Application.start(Mix.Project.config()[:app])
  end

  def migrate! do
    path = Application.app_dir(:todos, "priv/repo/migrations")
    Ecto.Migrator.run(Todos.Repo, path, :up, all: true)
  end
end

# Import helper functions into IEx session scope
import IExHelpers
