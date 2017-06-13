Feature: Sistema de Notificação
  As a usuário Administrador
  I want to receber notificações quando algum departamento precise fazer despacho de lixo químico 
  So that eu posso fazer a licitação de despacho de lixo.
  
    @a1
    Scenario: O peso da quantidade de resíduos já cadastrados no sistema é maior ou igual ao valor mínimo para fazer a licitação
        Given o sistema possui o departamento de "Fisica"
        And o sistema possui o laboratório de "Fisica 1"
        And o sistema possui o resíduo "Cloreto de Potassio" cadastrado no laboratorio de "Fisica 1"
        And o peso limitante do sistema é "7500"kg
        And o peso de resíduos total é "6700"kg
        When o usuário adiciona "900"kg do resíduo "Cloreto de Potassio" no laboratorio de "Fisica 1"
        Then o sistema verifica que o peso total é maior ou igual ao limite mínimo
        And o sistema gera uma notificação de limite máximo atingido
    
    @a2
    Scenario: O peso da quantidade de resíduos já cadastrados no sistema é maior ou igual que o limite mínimo para emitir um alerta
        Given o sistema possui o departamento de "Quimica"
        And o sistema possui o laboratório de "Quimica 1"
        And o sistema possui o resíduo "Acido Cloridrico" cadastrado no laboratorio de "Quimica 1"
        And o peso mínimo para afirmar que está próximo do limitante é de "7000"kg
        And o peso de resíduos total é "6600"kg
        When o usuário adiciona "500"kg do resíduo "Acido Cloridrico" no laboratorio de "Quimica 1"
        Then o sistema verifica que o peso total é maior que o limite mínimo para emitir um alerta
        And o sistema gera uma notificação de alerta de peso próximo ao limite máximo para fazer uma licitação
    
    @a3
    Scenario: Ver a notificação que a quantidade de resíduos está perto do peso mínimo para fazer a licitação
        Given o peso próximo ao limitante do sistema é "7000"kg
        And que a soma dos pesos dos resíduos cadastrados é "7100"kg
        When eu entro no sistema
        Then eu vejo uma notificação de alerta que o peso dos resíduos do departamento está se aproximando do peso mínimo para fazer a licitação
    
    @a4
    Scenario: Ver a notificação que a quantidade de resíduos é maior ou igual do peso mínimo para fazer a licitação
        Given o limitante do sistema é "7500"kg
        And que a soma dos pesos dos resíduos cadastrados é "7600"kg
        When eu entro no sistema
        Then eu vejo uma notificação de requisição de que o peso dos resíduos do departamento está igual ou maior que o mínimo para fazer a licitação.