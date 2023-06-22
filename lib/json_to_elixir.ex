defmodule JTE do
  @moduledoc """
  JTE keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.

  """

  def convert_map(map) when is_map(map) do
    IO.inspect(
      quote do
        defmodule JSON do
          defmodule Other do
            defstruct bar: ""
          end

          defstruct foo: ""
        end
      end
    )

    inital_state =
      {:defmodule, [context: JTE, imports: [{2, Kernel}]],
       [{:__aliases__, [alias: false], [:JSON]}, [do: {:__block__, [], []}]]}

    for {key, value} <- map, reduce: inital_state do
      acc ->
        case quote do: value do
          {%{}, _, _} ->
            append_module(acc, key, value)
        end
    end
  end

  defp type(t) when is_map(t), do: :map

  defp append_module(ast, key, value) do
    {:defmodule, metadata, [do: {:__block__, [], children}]} = ast

    module =
      {:defmodule, [context: JTE, imports: [{2, Kernel}]],
       [
         {:__aliases__, [alias: false], [String.to_atom(Macro.camelize(key))]},
         []
       ]}

    children = [module | children]

    {:defmodule, metadata, [do: {:__block__, [], children}]}
  end
end
