defmodule Inmana.WelcomerTest do
  # Expoe as ferramentas de teste do ExUnit, que é tipo o jasmine
  # ,async: true executa todos os testes asyncronamente, PORÉM usar só com Postgre. Mais nas anotações
  use ExUnit.Case, async: true

  # Crio um alias do modulo que estou testando para poder usar as funções dele e testar
  alias Inmana.Welcomer

  # Aqui é o describe para descrever um teste de uma função, no caso ele coloca o nome da função e a
  # aridade ou ariedade da função, que é 1 (a quantidade de argumentos recebidas)
  # E dentro testo todas as possibilidades dessa função, no caso como tenho o evaluate que é uma defp
  # e que por pattern match tem 3 possibilidades (branches), então preciso fazer 3 tests
  describe "welcome/1" do
    # Aqui seria tipo o it('should')
    test "when the user is special, returns a special message" do
      # BLOCO DE SETUP DO TESTE - ELE USA AQUELE ESQUEMA DE AAA
      # Aqui crio o mock do que quero testar
      params = %{"name" => "banana", "age" => "42"}
      # Crio uma variavel com o resultado que espero ter com a execução da função
      expected_result = {:ok, "You are very special banana"}
      # Depois chamo a função de welcome e passo os parametros mockados, esperando um resultado
      result = Welcomer.welcome(params)
      # Uso o assert para fazer o teste, esperando que o resultado da função seja igual a expected_result
      assert result == expected_result
    end

    test "when the user is not special, returns a message" do
      params = %{"name" => "gabriel", "age" => "25"}
      expected_result = {:ok, "Welcome gabriel"}
      result = Welcomer.welcome(params)
      assert result == expected_result
    end

    test "when the user is underage, returns an error" do
      params = %{"name" => "gabriel", "age" => "16"}
      expected_result = {:error, "You shall not pass, gabriel"}
      result = Welcomer.welcome(params)
      assert result == expected_result
    end
  end
end
