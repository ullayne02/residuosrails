@department = nil
porcent = 0.93333333

Given(/^o sistema possui o departamento de "([^"]*)"$/) do |dep_name|
  dep_params = {department: {name: dep_name}}
  @department = create_department(dep_params)
  expect(@department).to_not be nil
end

Given(/^o sistema possui o laboratório de "([^"]*)"$/) do |lab_name|
  dep = Department.find_by(name: @department.name)
  lab_params = {laboratory: {name: lab_name, department_id: dep.id}}
  lab = create_laboratory(lab_params)
  expect(lab).to_not be nil
end

Given(/^o sistema possui o resíduo "([^"]*)" cadastrado no laboratorio de "([^"]*)"$/) do |res_name, lab_name|
  lab = Laboratory.find_by(name: lab_name)
  expect(lab).to_not be nil
  res_params = {residue: {name: res_name, laboratory_id: lab.id}}
  res = create_residue(res_params)
  expect(res).to_not be nil
end

Given(/^o peso limitante do sistema é "([^"]*)"kg$/) do |max_weight|
  col_params = {collection: {max_value: max_weight.to_f()}}
  col = create_collection(col_params)
  expect(col).to_not be nil
end

Given(/^o peso de resíduos total é "([^"]*)"kg$/) do |total_weight|
  col = Collection.last
  expect(col).to_not be nil
  
  lab_params = {laboratory: {name: "Laboratorio2", department_id: @department.id}}
  lab = create_laboratory(lab_params)
  expect(lab).to_not be nil
  
  res_params = {residue: {name: 'residuo2', laboratory_id: lab.id, collection_id: col.id}}
  res = create_residue(res_params)
  expect(res).to_not be nil
  
  reg_params = {register: {weight: total_weight.to_f(), residue_id: res.id}}
  reg = create_register(reg_params)
  expect(reg).to_not be nil
end

When(/^o usuário adiciona "([^"]*)"kg do resíduo "([^"]*)" no laboratorio de "([^"]*)"$/) do |weight, res_name, lab_name|
  lab = Laboratory.find_by(name: lab_name)
  expect(lab).to_not be nil
  res = Residue.find_by(name: res_name)
  expect(res).to_not be nil
  
  reg_params = {register: {weight: weight.to_f(), residue_id: res.id}}
  reg = create_register(reg_params)
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
  
  col_params = {collection: {max_value: max_weight}}
  col = create_collection(col_params)
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

################################################# Testes GUI #########################################################################

Given(/^o peso próximo ao limitante do sistema é "([^"]*)"kg$/) do |max_value_close|
  max_weight = max_value_close.to_f() * (1/porcent).to_f()
  create_collection_gui(max_weight)
end

Given(/^que a soma dos pesos dos resíduos cadastrados é "([^"]*)"kg$/) do |total_weight|
  dep_name = "dep1"
  lab_name = "lab1"
  res_name1 = "res1"
  res_name2 = "res2"
  
  visit '/departments/new'
  fill_in('department_name', :with => dep_name)
  click_button 'Create Department'
  
  visit '/laboratories/new'
  fill_in('laboratory_name', :with => lab_name)
  page.select dep_name, :from => 'laboratory_department_id'
  click_button 'Create Laboratory'
  
  create_residue_gui(res_name1, lab_name)
  
  create_residue_gui(res_name2, lab_name)
  
  weight = total_weight.to_f()/2
  
  create_register_gui(weight, res_name1)
  
  create_register_gui(weight, res_name2)
  
end

When(/^eu entro no sistema$/) do
  visit '/main_adm'
end

Then(/^eu vejo uma notificação de alerta que o peso dos resíduos do departamento está se aproximando do peso mínimo para fazer a licitação$/) do
  element = find("td", text: "O peso está próximo do peso mínimo para fazer uma licitação")
  
  expect(element).to_not be nil
end

Given(/^o limitante do sistema é "([^"]*)"kg$/) do |max_weight|
  create_collection_gui(max_weight)
end

Then(/^eu vejo uma notificação de requisição de que o peso dos resíduos do departamento está igual ou maior que o mínimo para fazer a licitação\.$/) do
  element = find("td", text: "Passou do peso limite, deve fazer uma licitação")
  
  expect(element).to_not be nil
end

################################################################  Methods  #######################################################################################

def create_department(dep)
    post '/departments', dep
    Department.find_by(name: dep[:department][:name])
end
  
def create_laboratory(lab)
    post '/laboratories', lab
    Laboratory.find_by(name: lab[:laboratory][:name], department_id: lab[:laboratory][:department_id])
end
  
def create_residue(res)
    post '/residues', res
    Residue.find_by(name: res[:residue][:name], laboratory_id: res[:residue][:laboratory_id])
end
  
def create_register(reg)
    post '/registers', reg
    Residue.find(reg[:register][:residue_id]).registers.last
end

def create_collection(col)
    post '/collections', col
    Collection.last
end

def create_residue_gui(name, lab_name)
  visit '/residues/new'
  fill_in('residue_name', :with => name)
  page.select lab_name, :from => 'residue_laboratory_id'
  click_button 'Create Residue'
end

def create_register_gui(weight, res_name)
  visit '/registers/new'
  fill_in('register_weight', :with => weight)
  page.select res_name, :from => 'register_residue_id'
  click_button 'Create Register'
end

def create_collection_gui(max_weight)
  visit '/collections/new'
  fill_in('collection_max_value', :with => max_weight)
  click_button 'Create Collection'
end