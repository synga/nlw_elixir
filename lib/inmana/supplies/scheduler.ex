defmodule Inmana.Supplies.Scheduler do
  # Para usar o genserver preciso colocar o use dele
  use GenServer

  # Alias do modulo que faz a criação do email de expiração
  alias Inmana.Supplies.ExpirationNotification

  # !!! CLIENT !!! METODO QUE VAI SER USADO NO MEU "CLIENT", NO MEU CÓDIGO !!!

  # Iniciar o meu GenServer a partir do meu modulo aqui de Scheduler; Então passo um state que é uma lista
  # mesmo que vazia; dentro uso a função GenServer, startando o server no meu modulo atual, passando uma
  # lista vazia (que poderia ser a lista vinda por parametros); E esse start_link já chama o init(), que
  # é uma função implicita do GenServer que starta o servidor
  def start_link(_state) do
    GenServer.start_link(__MODULE__, %{})
  end

  # !!! SERVER !!! IMPLEMENTAÇÃO DO SERVER COM GENSERVER !!!

  # PAra inicializar o GenServer temos a função init, ela recebe o estado inicial, que se não vem, vai
  # ter o valor padrão de uma lista vazia. O operador \\ faz isso de atribuir um valor padrão caso algo
  # não exista
  @impl true
  def init(state \\ %{}) do
    schedule_notification()
    {:ok, state}
  end

  defp schedule_notification do
    # Vai enviar uma mensagem usando o send_after; Essa mensagem vai ser enviada para o processo atual
    # sendo executado (o servidor ou o localhost); Vai ser do tipo :generate para gerar uma nova mensagem;
    # e vai ser enviada após 10 segundos; como temos o handle_info, vai ser pego por ele
    # Para executar de 1 em 1 semana: 1000 * 60 * 60 * 24 * 7
    Process.send_after(self(), :generate, 1000 * 10)
  end

  # Handle_info serve para receber qualquer mensagem; Ou seja de qualquer processo, qualquer mensagem,
  # cai aqui no handle_info; Ele pega tudo, não só desse genserver alias
  # O que é feito aqui: ao iniciar o GenServer ele chama o schedule_notification, que vai agendar uma
  # notificação para depois de 10 segundos (ou 7 dias); Ao executar esse processo cai aqui no handle_info;
  # Vou chamar a função que envia os emails; Então faço o agendamento novamente; Devolvo uma resposta "vazia"
  @impl true
  def handle_info(_msg, state) do
    ExpirationNotification.send()

    schedule_notification()

    {:noreply, state}
  end

  # isso aqui é async!!!
  # O valor do GenServer que faz essa criação de um server é o cast, por isso o metodo handle_cast.
  # O que faz aqui é que por pattern match, se vir uma tupla com um :put, uma chave e um valor, junto do
  # estado atual da lista de tarefas a serem excutadas, então ele executa esse handle_cast.
  # O valor de :put pode ser o que eu quiser definir, não é um valor que precisa vir assim
  @impl true
  def handle_cast({:put, key, value}, state) do
    # :noreply pois não vou devolver nada pra função que deu o cast, ou pro usuario; Depois na lista do
    # meu state, na posição da chave, coloco o valor que veio. Pois a ideia é fazer o genserver manter o
    # estado da lista, pois os itens são imutaveis e o put em uma lista não faz nada, não altera ela
    {:noreply, Map.put(state, key, value)}
  end

  # isso aqui é sincrono. Se chamou precisa já devolver a resposta!!!
  # Vai apenas pegar o valor de uma chave no state que o genserver está mantendo
    @impl true
    def handle_call({:get, key}, _from, state) do
    # Aqui já devolvo o deply pois já estou respondendo pra chamada o valor, ele é sincrono, precisa
    # devolver o valor; Aqui não modifico o valor, é só uma consulta mesmo
    {:reply, Map.get(state, key), state}
  end
end
