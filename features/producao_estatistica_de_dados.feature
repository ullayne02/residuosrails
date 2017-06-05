Feature: Produção Estatística de Dados
  As a usuário Administrador
  I want to ter acesso em tempo real a informações geradas pelo sistema referentes aos resíduos e departamentos
  So that posso ter acesso a resíduos acumulados, previsão de notificação de coleta.
  
@b1
Scenario: Sistema calcula previsão de coleta baseado em resíduos cadastrados
  Given existe "800" kg de residuos cadastrados no sistema
  And a ultima coleta foi feita a "10" dias
  And o limite de peso de residuos é "7500" kg
  When eu tento gerar a "Previsão de Notificação de Coleta"
  Then o sistema calcula a média de "80" kg/dia
  And o sistema calcula que faltam "6700" kg para atingir o limite
  And o sistema calcula que faltam "84" dias para fazer a licitação

@b2
Scenario: Gerar Dados de Total de Resíduos Acumulados por Tipo de Resíduo com resíduos cadastrados no sistema
  Given existe "800" kg de "Ácido Acético" de tipo "Líquido Inflamável" cadastrado no sistema
  And existe "300" kg de "Etanol" de tipo "Líquido Inflamável" cadastrado no sistema
  And existe "1200" kg de "Cal" de tipo "Sólido Inorgânico" cadastrado no sistema
  When eu tento gerar o "Total de Resíduos Acumulados por Tipo"
  Then o sistema calcula o  "Total de Resíduos Acumulados por Tipo" com "1100" kg de substâncias de tipo "Líquido Inflamável" e "1200" kg de substâncias de tipo "Sólido Inorgânico"
  
@b3
Scenario: Gerar a Notificação de Coleta sem resíduos cadastrados, GUI
  Given eu vejo a lista de "Resíduos Cadastrados" vazia
  When eu seleciono a opção "Gerar Previsão de Notificação de Coleta"
  Then eu vejo uma mensagem informando que não há resíduos cadastrados

@b4
Scenario: Gerar Dados de Total de Resíduos Acumulados por Tipo de Resíduo baseado em resíduos cadastrados, GUI
  Given eu vejo a lista de "Resíduos cadastrados" com "800" kg de "Ácido Acético" de tipo "Líquido Inflamável" e "300" kg de "Etanol" de tipo "Líquido Inflamável" e "1200" kg de "Cal" de tipo "Sólido Inorgânico"
  When eu seleciono a opção "Gerar Total de Resíduos Acumulados por Tipo"
  Then eu vejo uma lista com o "Total de Resíduos Acumulados por Tipo" com  "1100" kg de substâncias de tipo "Líquidos Inflamáveis" e "1200" kg de substâncias de tipo "Sólidos Inorgânicos"
  #@b5
  #@b6
  #@b7
  #@b8