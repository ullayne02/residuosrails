Feature: Validação de Facilitador
  As a usuário Administrador
  I want to validar o acesso de um Facilitador ao sistema ligado a um dado Departamento
  So that posso conectar um Facilitador a um Departamento e liberar o acesso dele ao sistema
 
  @d1
 Scenario: O facilitador solicita  acesso ao laboratório e o facilitador não está vinculado a nenhum laboratório
    Given que o facilitador de login "joc" não está associado a nenhum laboratório
    And o laboratorio "quimica" nao possui nenhum facilitador associado a ele 
    When o sistema verifica se o facilitador "joc" está associado a um laboratório.
    Then o sistema faz a requisicao do facilitador "joc" ao laboratorio "quimica"

  @d2
  Scenario: Sistema gera uma notificacao para cada nova requisição
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
  Scenario: Um administrador pede acesso a um laboratorio
    Given o administrador "joc" esta associado ao sistema
    And o laboratorio "quimica" esta associado ao sistema
    When o administrador "joc" pede acesso ao laboratório "quimica"
    Then o sistema mostra uma notificacao avisando que um administrador nao pode pedir acesso a laboratorio
    
 @d6
 Scenario: Um administrador pede acesso a um laboratorio
    Given o administrador "joc" esta associado ao sistema
    And o laboratorio "quimica" esta associado ao sistema
    When o administrador "joc" pede acesso ao laboratório "quimica"
    Then o sistema gera uma notificacao informando que o facilitador "joc" nao pode se associar a mais de um laboratorio
    
  @d7 
  Scenario: O administrador ver as notificacoes de novas requisicoes de acesso a laboratorio 
    Given estou na pagina de administrador 
    When eu estou na pagina de requisicoes 
    And eu vejo que o facilitador "miriane" fez uma requisicao ao laboratorio "fisica"
    Then o mostra uma notificacao avisando que o facilitador "miriane" fez uma requisicao para o laboratorio "fisica"
  
  @d8 
  Scenario: O facilitador já associado a um laboratório  solo e pede acesso a outro laboratório
    Given o facilitador "lar" esta associado ao laboratorio "fisica"
    When o facilitador "lar" faz requisicao de acesso ao laboratorio "fisica"
    Then o sistema gera uma notificacao informando que o facilitador "lar" nao pode se associar a mais de um laboratorio

  
  @d9
  Scenario: Geração de notificação de rejeição de solicitação de acesso
	  Given que o facilitador de login "vrvs" está cadastrado no sistema
	  And o laboratório "quimica" está cadastrado no sistema
	  And existe uma solicitação de acesso do facilitador "vrvs" ao laboratório de "quimica"
	  When o administrador rejeita a solicitação
	  Then o sistema gera uma notificação de rejeição da solicitação
	  
  @d10
	Scenario: Geração de notificação de aprovação de solicitação de acesso
	  Given que o facilitador de login "vrvs" está cadastrado no sistema
	  And o laboratório "quimica" está cadastrado no sistema
	  And existe uma solicitação de acesso do facilitador "vrvs" ao laboratório de "quimica"
	  When o administrador aceita a solicitação
	  Then o sistema gera uma notificação de aceitação da solicitação
	  
  @d11
  Scenario: Recebimento de notificação de rejeição de solicitação de acesso
	  Given o facilitador de login "vrvs" é um usuário do sistema
	  And o facilitador "vrvs" solicitou acesso ao laboratório de "quimica"
	  When o administrador clica no botão para rejeitar a solicitação
	  Then o facilitador vê uma notificação de rejeição de solicitação
	  
  @d12
	Scenario: Recebimento de notificação de rejeição de solicitação de acesso
	  Given o facilitador de login "vrvs" é um usuário do sistema
	  And o facilitador "vrvs" solicitou acesso ao laboratório de "quimica"
	  When o administrador clica no botão para aceitar a solicitação
	  Then o facilitador vê uma notificação de aceitação de solicitação

   