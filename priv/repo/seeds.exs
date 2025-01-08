# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
alias Todos.Repo
alias Todos.Data.Schema.{Story, Task}

# Stories
groceries =
  %Story{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska",
    name: "Groceries",
    description: "This is a list of groceries I need to buy."
  }
  |> Repo.insert!()

hockey_gear =
  %Story{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskb",
    name: "Hockey Gear",
    description: "This is a list of hockey equipment I want to buy."
  }
  |> Repo.insert!()

# Tasks
tasks = [
  %Task{name: "Bacon", status: :todo, story: groceries},
  %Task{name: "Eggs", status: :todo, story: groceries},
  %Task{name: "Bread", status: :todo, story: groceries},
  %Task{name: "Butter", status: :todo, story: groceries},
  %Task{name: "Coffee", status: :todo, story: groceries},
  %Task{name: "Stick: CCM Vizion: P28", status: :todo, story: hockey_gear},
  %Task{name: "Stick: CCM Vizion: P90TM", status: :todo, story: hockey_gear}
]

Repo.transaction(fn ->
  Enum.map(tasks, &Repo.insert!/1)
end)
