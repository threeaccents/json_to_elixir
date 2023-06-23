defmodule JTE.Parser do
  def parse([{:eof, _}], ast), do: ast

  def parse([token | rest], ast) do
    case token do
      {:lbrace, _} ->
        nil
    end
  end
end
