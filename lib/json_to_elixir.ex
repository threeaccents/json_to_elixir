defmodule JTE do
  alias JTE.Lexer
  alias JTE.Parser
  alias JTE.Eval

  require Logger

  @doc """
  This is the entry point for transforming JSON to Elixir.
  It encapsualtes all the steps needed to accomplish the task.
  """
  @spec transform(input :: String.t()) :: {:ok, code :: String.t()} | {:error, term()}
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
