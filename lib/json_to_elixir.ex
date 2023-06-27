defmodule JTE do
  @moduledoc """
  JTE keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.

  """
  alias JTE.Lexer
  alias JTE.Parser
  alias JTE.Eval

  require Logger

  def transform(input) when is_binary(input) do
    case Jason.decode(input) do
      {:ok, parsed_json} ->
        {:ok,
         Jason.encode!(parsed_json)
         |> Lexer.lex()
         |> Parser.parse()
         |> Eval.execute()}

      {:error, reason} ->
        Logger.error("failed to parse json #{inspect(reason)}")
        {:error, reason}
    end
  end
end
