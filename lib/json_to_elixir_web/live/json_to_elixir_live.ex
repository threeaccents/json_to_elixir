defmodule JTEWeb.JsonToElixirLive do
  use JTEWeb, :live_view

  require Logger

  def mount(_params, _session, socket) do
    {:ok, assign(socket, result: "Elixir will be shown here")}
  end

  def render(assigns) do
    IO.inspect("rerender #{inspect(assigns)}")

    ~H"""
    <div class="w-full h-full ">
      <div class="grid grid-cols-2 h-full gap-4">
        <div class="h-full p-4 border-r">
          <form phx-change="update" class="h-full">
            <LiveMonacoEditor.code_editor
              id="json"
              path="my.json"
              opts={
                Map.merge(
                  LiveMonacoEditor.default_opts(),
                  %{"language" => "json"}
                )
              }
              phx-debounce={1000}
              style="height: 100%"
              value="Paste JSON here"
            />
          </form>
        </div>
        <div class="h-full p-4">
          <LiveMonacoEditor.code_editor
            id="elixir"
            path="my.elixir"
            opts={
              Map.merge(
                LiveMonacoEditor.default_opts(),
                %{"language" => "elixir"}
              )
            }
            phx-debounce={1000}
            style="height: 100%"
            value={@result}
          />
        </div>
      </div>
    </div>
    """
  end

  def handle_event(
        "update",
        %{
          "live_monaco_editor" => %{"my.json" => json}
        },
        socket
      ) do
    case Jason.encode(json) do
      {:ok, parsed_json} ->
        result =
          Jason.decode!(parsed_json)
          |> JTE.Lexer.tokenize()
          |> JTE.Parser.parse()
          |> Macro.to_string()

        {:noreply, assign(socket, result: result)}

      _ ->
        Logger.error("failed to parse json")
        {:noreply, socket}
    end
  end
end
