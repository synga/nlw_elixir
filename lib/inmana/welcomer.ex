# orientado a objeto = cria classes, atributos e objetos, metodos, etc.
# no funcional = trabalha apenas com funções; modulos são formas de agrupar funções
# funcional é composição de funções; funções puras, não tem efeitos colaterais

# definimos o modulo da nossa aplicação com um nome especifico; Tem que ser maiusculo
defmodule Inmana.Welcomer do

  # Receber um nome e uma idade do usuario;
  # Se o usuario chamar banana e tiver idade 42, ele recebe uma mensagem especial;
  # Se o usuario for maior de idade, ele recebe uma mensagem normal;
  # Se o usuario for menor de idade, retornamos um erro;
  # Temos que tratar o nome do usuario para entradas "erradas";

  # def cria uma função, do abre o bloco de execução
  # Atualização em 1h16m; Ele usou o pattern match (meio que desestruturação aqui) pra dizer que
  # o valor que vem no map com o nome de "name" vai ser atribuido a name, o mesmo com age
  def welcome(%{"name" => name, "age" => age}) do
    # Sempre vai receber como string e converter para int;
    age = String.to_integer(age)

    # IO.inspect() inspeciona e imprime no device, é como um console.log
    # IO.inspect(name)
    # IO.inspect(age)

    # No Elixir o valor que vem do pipe fica implicito no função, ele já sabe que o valor vai pro
    # primeiro parametro. Por isso se eu crio uma função que recebe 2 argumentos como o evaluate()
    # automaticamente o elixir sabe que o resultado do pipe vai para o primeiro argumento e só
    # preciso passar o segundo.
    name
    |> String.trim()
    |> String.downcase()
    |> evaluate(age)
  end

  # defp define uma função privada, provavelmente não pode ser usada fora desse modulo
  # como existe o pattern match, aqui eu estou criando uma função evaluate que recebe já os valores
  # que eu espero receber para poder retornar o valor que quero; no caso funciona como if/else
  # aqui. Pois posso ter varias funcões com argumentos diferentes que retornam valores diferentes
  defp evaluate("banana", 42) do
    # Não preciso dar um return, ta implicito isso
    # Retorno uma tupla com ok, pois passou e está tudo certo
    {:ok, "You are very special banana"}
  end

  # Agora uma função evaluate que não bate no evaluate acima, mas que recebe um name qualquer e um age
  # qualquer;
  # O _ antes do nome do argumento meio que comenta ele, diz que não sera utilizado
  # O when é chamado de guard, ele faz a condição; então vai entrar nessa função quando o age for maior
  # ou igual a 18; O guard da mais funcionalidade ao pattern match
  defp evaluate(name, age) when age >= 18 do
    {:ok, "Welcome #{name}"}
  end

  # Aqui seria o "else" do meu "if/else" criado em todas as funções; Se não passa em nenhum pattern
  # match ele vai cair aqui; Vai realmente de cima pra baixo executando; Como não cai nos de cima, cai
  # aqui
  defp evaluate(name, _age) do
    # Retorno uma tupla de erro, com a mensagem de erro depois
    {:error, "You shall not pass, #{name}"}
  end
end
