# Module para pegar itens por expiração
defmodule Inmana.Supplies.GetByExpiration do
  # Import do Ecto.Query para usar todas as funcionalidades de query do banco. E por query não digo
  # só os get,create,add, essas coisas, são where, condições e etc;
  # O Ecto usa DSL como linguagem de query
  import Ecto.Query

  alias Inmana.{Repo, Restaurant, Supply}

  # Não preciso de parametros aqui, vai só servir pra retornar uma lista de emails e seus supplies
  def call do
    # Dia atual
    today = Date.utc_today()
    # Data de inicio da semana
    beginning_of_week = Date.beginning_of_week(today)
    # Data do fim da semana
    end_of_week = Date.end_of_week(today)

    # criando uma query com o DSL do Ecto;
    # Quero pegar supply do meu Schema de Supply, esse supply pode ser o nome que eu quiser
    # onde a data de expiração seja maior ou igual ao começo da semana e menor ou igual ao final
    # O ^ na query é o pin operator; Ele fixa um valor; Falo mais nas anotações
    query =
      from supply in Supply,
        where:
          supply.expiration_date >= ^beginning_of_week and supply.expiration_date <= ^end_of_week,
        # A query do ecto não carrega automaticamente dados de relacionamentos pai/filho, pra que ele faça
        # isso eu posso passar na query a função preload indicando em uma lista que itens quero trazer junto
        # Que no meu caso é um restaurant; sera que consigo fazer algo tipo Graphql?
        preload: [:restaurant]

    # Pego a query; Passo para o Repo.all para executar a query; Depois passo por um Enum que vai usar a
    # função group_by, que ela recebe uma lista (vinda no pipe), e depois uma função que por pattern match
    # pego que tem que ser um supply e que dentro tem que ter um restaurante com email; e agrupo pelo
    # email, ai finalizo a função
    query
    |> Repo.all()
    |> Enum.group_by(fn %Supply{restaurant: %Restaurant{email: email}} -> email end)
  end
end
