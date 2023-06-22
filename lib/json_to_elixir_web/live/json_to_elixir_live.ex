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
          <div contenteditable class="h-full outline-none">
        <span>Paste JSON here</span>
        </div>
        </div>
        <div class="h-full p-4">
          <span>Elixir output here</span>
        </div>
      </div>
    </div>
    """
  end
end
