# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
alias Todos.Repo
alias Todos.Data.Schema.Story

# Stories
Repo.insert!(%Story{
  blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska",
  name: "Books",
  description: "This is a list of books I'd like to read."
})

Repo.insert!(%Story{
  blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska",
  name: "Groceries",
  description: "This is a list of groceries I need to buy."
})
