defprotocol Todos.Dto do
  @moduledoc "Create data transfer objects."
  @spec from_schema(struct()) :: map()
  def from_schema(struct)
end
