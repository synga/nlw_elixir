# Schema do banco; model é o modelo de negócio com banco de dados
# no elixir não tem propriamente um model, mas sim um schema;
# o schema não tem comportamento igual um model, ele só serve pra modelar o banco mesmo
defmodule Inmana.Restaurant do
  # use significa que sou usar o modulo no contexto atual, ou seja dentro do meu modulo
  # seria como uma injeção de dependencia?
  use Ecto.Schema
  # O import serve para importar funções e macros de outros modulos
  import Ecto.Changeset
  # Aias do supply
  alias Inmana.Supply

  # O @nome e "valor" é uma variavel de modulo, uma constante que serve só aqui dentro
  # aqui são definidas as configurações da chave primaria; então a primary_key do meu schema é
  # o campo :id, ele é do tipo :binary_id e é gerado automaticamente.
  @primary_key {:id, :binary_id, autogenerate: true}

  # Crio uma variavel de modulo com email e name para ser reutilizado com facilidade apenas chamando ela
  @required_params [:email, :name]

  # Falo pro encoder de JSON que ele deve mostrar os dados do required_params como json e concateno
  # essa lista com mais uma lista que tem o id
  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  # Criando a Schema propriamente dito com os mesmos campos criados na migration. Inclusive o timestamp
  schema "restaurants" do
    field :email, :string
    field :name, :string

    # Aqui digo que um restaurante tem muitos suprimentos, passo o nome da tabela e o modulo referente
    has_many :supplies, Supply

    timestamps()
  end

  # o changeset é um conjunto de mudanças, é responsavel por receber parametros e fazer o casting
  # também faz validações
  def changeset(params) do
    # esse __MODULE__ pega o nome do modulo que estou atualmente, então fazer %__MODULE__{} é a mesma
    # coisa que fazer %Inmana.Restaurant{}. Crio o changeset aqui usando pipes
    %__MODULE__{}
      # faz cating dos dados que vieram por params e pega email e name nele, atribuindo por pattern match
    |> cast(params, @required_params)
      # valida o email e name que vieram por params, checando se eles existem, pois são obrigatorios
    |> validate_required(@required_params)
    |> validate_length(:name, min: 2) # nome deve ter no minimo 2 caracteres
    |> validate_format(:email, ~r/@/) # isso é uma validação usando regex, que ele chama de sigil
    |> unique_constraint([:email]) # email deve ser unico

    # !!!ATENÇÃO!!! sempre lembrar de como os dados são passados pros pipes, os valores do retorno de
    # uma função são sempre passados como primeiro argumento para a próxima função no pipe; qualquer
    # outro argumento passado entraria como segundo argumento na função.
  end
end
