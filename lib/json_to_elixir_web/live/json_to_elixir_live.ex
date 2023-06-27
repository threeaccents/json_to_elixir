defmodule JTEWeb.JsonToElixirLive do
  use JTEWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="w-full h-full ">
      <div class="grid grid-cols-2 h-full gap-4">
        <div class="h-full p-4 border-r">
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
        </div>
        <div class="h-full p-4">
          <LiveMonacoEditor.code_editor
            id="elixir"
            path="my.ex"
            opts={
              Map.merge(
                LiveMonacoEditor.default_opts(),
                %{"language" => "elixir", "theme" => "vs"}
              )
            }
            phx-debounce={1000}
            style="height: 100%"
            value="Elixir output here"
          />
        </div>
      </div>
    </div>
    """
  end

  def handle_event("editor-was-updated", %{"value" => json}, socket) do
    case JTE.transform(json) do
      {:ok, result} ->
        {:noreply, LiveMonacoEditor.set_value(socket, result, to: "my.ex")}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end
end
