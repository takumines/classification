defmodule ClassificationWeb.PageLive do
  use ClassificationWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:upload_file, nil)
      |> assign(:ans, "")
      |> assign(:score, nil)
      |> assign(:filename, nil)
      |> allow_upload(
        :image,
        accept: ~w(.jpg .jpeg .png),
        progress: &handle_progress/3,
        auto_upload: true
      )
    }
  end

  def handle_progress(:image, entry, socket) when entry.done? == false, do: {:noreply, socket}

  def handle_progress(:image, entry, socket) do
    upload_file =
      consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
        File.read(path)
      end)
      |> hd()

    {
      :noreply,
      socket
      |> assign(:upload_file, upload_file)
      |> assign(:filename, entry.client_name)
    }
  end

  @impl true
  def handle_event("upload", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("predict", _params, socket) do
    tensor =
      socket.assigns.upload_file
      |> StbImage.read_binary!()
      |> StbImage.to_nx()

    %{predictions: [%{label: ans, score: score}]} =
      Nx.Serving.batched_run(Classification.Serving, tensor)

    {
      :noreply,
      socket
      |> assign(:ans, ans)
      |> assign(:score, score)
    }
  end

  def handle_event("clear", _params, socket) do
    {
      :noreply,
      socket
      |> assign(:upload_file, nil)
      |> assign(:filename, "")
      |> assign(:ans, "")
      |> assign(:score, nil)
    }
  end
end
