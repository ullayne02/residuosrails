@department = nil
@laboratorie = nil
porcent = 0.93333333

Given(/^o sistema possui o departamento de "([^"]*)"$/) do |dep_name|
  dep_params = {department: {name: dep_name}}
  post '/departments', dep_params
  @department = Department.find_by(name: dep_name)
  expect(@department).to_not be nil
end

Given(/^o sistema possui o laboratório de "([^"]*)"$/) do |lab_name|
  dep = Department.find_by(name: @department.name)
  lab_params = {laboratory: {name: lab_name, department_id: dep.id}}
  post '/laboratories', lab_params
  @laboratorie = Laboratory.find_by(name: lab_name)
  expect(@laboratorie).to_not be nil
end

Given(/^o sistema possui o resíduo "([^"]*)" cadastrado no laboratorio de "([^"]*)"$/) do |res_name, lab_name|
  lab = Laboratory.find_by(name: lab_name)
  expect(lab).to_not be nil
  res_params = {residue: {name: res_name, laboratory_id: lab.id}}
  post '/residues', res_params
  res = Residue.find_by(name: res_name)
  expect(res).to_not be nil
end

Given(/^o peso limitante do sistema é "([^"]*)"kg$/) do |max_weight|
  col = {collection: {max_value: max_weight.to_f()}}
  post '/collections', col
  col = Collection.last
  expect(col).to_not be nil
end

Given(/^o peso de resíduos total é "([^"]*)"kg$/) do |total_weight|
  col = Collection.last
  expect(col).to_not be nil
  
  lab_params = {laboratory: {name: "Laboratorio2", department_id: @department.id}}
  post '/laboratories', lab_params
  lab = Laboratory.find_by(name: lab_params[:laboratory][:name])
  expect(lab).to_not be nil
  
  res_params = {residue: {name: 'residuo2', laboratory_id: lab.id, collection_id: col.id}}
  post '/residues', res_params
  res = Residue.find_by(name: res_params[:residue][:name])
  expect(res).to_not be nil
  
  reg_params = {register: {weight: total_weight.to_f(), residue_id: res.id}}
  post '/registers', reg_params
  reg = Register.last
  expect(reg).to_not be nil
end

When(/^o usuário adiciona "([^"]*)"kg do resíduo "([^"]*)" no laboratorio de "([^"]*)"$/) do |weight, res_name, lab_name|
  lab = Laboratory.find_by(name: lab_name)
  expect(lab).to_not be nil
  res = Residue.find_by(name: res_name)
  expect(res).to_not be nil
  
  reg_params = {register: {weight: weight.to_f(), residue_id: res.id}}
  post '/registers', reg_params
  reg = Register.last
  expect(reg).to_not be nil
  
end

Then(/^o sistema verifica que o peso total é maior ou igual ao limite mínimo$/) do
  col = Collection.last
  expect(col).to_not be nil
  
  total = 0
  Residue.all.each do |res|
    total += res.registers.where(created_at: [Collection.last.created_at..Time.now]).sum(:weight)
  end
  expect(total).to be > col.max_value
end

Then(/^o sistema gera uma notificação de limite máximo atingido$/) do
  col = Collection.last
  expect(col).to_not be nil
  
  param_not = {notification: {message: "abc", collection_id: col.id}}
  post '/notifications', param_not
  p_not = Notification.find_by(collection_id: col.id)
  expect(p_not).to_not be nil 
  
end

Given(/^o peso mínimo para afirmar que está próximo do limitante é de "([^"]*)"kg$/) do |max_value_close|
  max_weight = max_value_close.to_f() * (1/porcent).to_f()
  
  col = {collection: {max_value: max_weight}}
  post '/collections', col
  col = Collection.last
  expect(col).to_not be nil
end

Then(/^o sistema verifica que o peso total é maior que o limite mínimo para emitir um alerta$/) do
  col = Collection.last
  expect(col).to_not be nil
  
  
  total = 0
  Residue.all.each do |res|
    total += res.registers.where(created_at: [Collection.last.created_at..Time.now]).sum(:weight)
  end
  
  expect(total).to be > (col.max_value*porcent)
end

Then(/^o sistema gera uma notificação de alerta de peso próximo ao limite máximo para fazer uma licitação$/) do
  col = Collection.last
  expect(col).to_not be nil
  
  param_not = {notification: {message: "cba", collection_id: col.id}}
  post '/notifications', param_not
  p_not = Notification.find_by(collection_id: col.id)
  expect(p_not).to_not be nil 
end

Given(/^que a soma dos pesos dos resíduos cadastrados é "([^"]*)"kg$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/^o peso próximo ao limitante do sistema é "([^"]*)"kg$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^eu entro no sistema$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^eu vejo uma notificação de alerta que o peso dos resíduos do departamento está se aproximando do peso mínimo para fazer a licitação$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/^o limitante do sistema é "([^"]*)"kg$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^eu vejo uma notificação de requisição de que o peso dos resíduos do departamento está igual ou maior que o mínimo para fazer a licitação\.$/) do
  pending # Write code here that turns the phrase above into concrete actions
end