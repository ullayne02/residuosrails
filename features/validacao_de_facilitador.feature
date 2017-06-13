Feature: Validação de Facilitador
  As a usuário Administrador
  I want to validar o acesso de um Facilitador ao sistema ligado a um dado Departamento
  So that posso conectar um Facilitador a um Departamento e liberar o acesso dele ao sistema
 
  @d1
 Scenario: O facilitador solicita  acesso ao laboratório e o facilitador não está vinculado a nenhum laboratório
    Given que o facilitador de login "joc" não está associado a nenhum laboratório
    When o facilitador "joc" faz uma requisicao de acesso para o laboratorio "quimica"
    And o sistema verifica se o facilitador "joc" está associado a um laboratório.
    Then o sistema faz a requisicao do facilitador "joc" ao laboratorio "quimica"

  @d2
  Scenario: O administrador recebe um email de aviso de nova requisição
    Given o adm "joc" esta asscoiado ao sistema
    When o facilitador "miriane" faz uma requisicao de acesso para o laboratorio "quimica"
    And o sistema verifica se o facilitador "miriane" está associado a um laboratório.    
    And o sistema faz a requisicao do facilitador "miriane" ao laboratorio "quimica"
    Then o sistema faz uma notificacao avisando que o facilitador "miriane" fez uma requisicao para o laboratorio "quimica"

  @d3
  Scenario: Administrador tem solicitações de acesso ao laboratório pendentes
    Given eu estou na pagina de requisicoes
    And existe uma requisicao pendente
    When eu clico em aceitar 
    Then eu vejo que a requisicao nao aparece mais 

  @d4
  Scenario: O facilitador já associado a um laboratório  solo e pede acesso a outro laboratório
    Given o facilitador "lar" esta associado ao laboratorio de "fisica"  
    When o facilitador "lar" faz uma requisição de acesso para o laboratório "quimica"
    Then eu vejo uma mensagem informando que o facilitador "lar" ja esta associado a um laboratório


  @d5
  Scenario: O administrador aceita ou rejeita uma requisição a um laboratório
    Given estou logado como "admin"
    When eu estou na "página de solicitações"
    Then eu aceito ou rejeito as solicitações pendentes dos facilitadores

  
