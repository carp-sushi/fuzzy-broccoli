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
  Repo.insert!(%Story{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska",
    name: "Groceries",
    description: "This is a list of groceries I need to buy."
  })

hockey_gear =
  Repo.insert!(%Story{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskb",
    name: "Hockey Gear",
    description: "This is a list of hockey equipment I want to buy."
  })

# Tasks
Repo.insert!(%Task{name: "Bacon", status: :todo, story: groceries})
Repo.insert!(%Task{name: "Eggs", status: :todo, story: groceries})
Repo.insert!(%Task{name: "Bread", status: :todo, story: groceries})
Repo.insert!(%Task{name: "Butter", status: :todo, story: groceries})
Repo.insert!(%Task{name: "Coffee", status: :todo, story: groceries})

Repo.insert!(%Task{name: "Stick: CCM Vizion", status: :todo, story: hockey_gear})
Repo.insert!(%Task{name: "Skates: CCM JetSpeed FT8 Pro", status: :todo, story: hockey_gear})
