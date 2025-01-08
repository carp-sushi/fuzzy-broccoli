# Set the sandbox ownership mode. This ensures that only a single connection is used for each test.
# Ecto.Adapters.SQL.Sandbox.mode(Todos.Repo, :manual)

# Define and inject a story keeper mock into the env.
Hammox.defmock(StoryKeeperMock, for: Todos.Data.Keeper.StoryKeeper)
Application.put_env(:todos, :story_keeper, StoryKeeperMock)

# Define and inject a task keeper mock into the env.
Hammox.defmock(TaskKeeperMock, for: Todos.Data.Keeper.TaskKeeper)
Application.put_env(:todos, :task_keeper, TaskKeeperMock)

# Start and run tests
ExUnit.start()
