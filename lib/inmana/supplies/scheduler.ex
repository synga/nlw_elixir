defmodule Inmana.Supplies.Scheduler do
  use GenServer

  alias Inmana.Supplies.ExpirationNotification

  # !!! CLIENT !!! METODO QUE VAI SER USADO NO MEU "CLIENT", NO MEU CÓDIGO !!!
  def start_link(_state) do
    GenServer.start_link(__MODULE__, %{})
  end

  # !!! SERVER !!! IMPLEMENTAÇÃO DO SERVER COM GENSERVER !!!
  @impl true
  def init(state \\ %{}) do
    schedule_notification()
    {:ok, state}
  end

  defp schedule_notification do
    # Para executar de 1 em 1 semana: 1000 * 60 * 60 * 24 * 7
    Process.send_after(self(), :generate, 1000 * 10)
  end

  @impl true
  def handle_info(_msg, state) do
    ExpirationNotification.send()

    schedule_notification()

    {:noreply, state}
  end

  @impl true
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end
end
