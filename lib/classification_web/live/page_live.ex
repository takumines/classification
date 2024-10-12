defmodule ClassificationWeb.PageLive do
  use ClassificationWeb, :live_view

  @impl true
  def mount(_param, _session, socket) do
    {:ok, socket}
  end
end
