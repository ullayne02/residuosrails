@collection = []
Given(/^existe "([^"]*)" kg de residuos cadastrados no sistema$/) do |res_weight|
 col = cad_col(0)
 expect(col).to_not be nil
 dep = cad_dep("Departamento de Genetica")
 expect(dep).to_not be nil
 lab = cad_lab("Laboratorio de Genetica Aplicada", dep.id)
 expect(lab).to_not be nil
 res = cad_res("Etanol",lab.id,"Líquido Inflamável")
 expect(res).to_not be nil
 reg = cad_reg(res_weight.to_f(),res.id)
 expect(reg).to_not be nil
end
 
Given(/^a ultima coleta foi feita a "([^"]*)" dias$/) do |last_collection|
 @collection = Collection.last
 @collection.created_at= (@collection.created_at.to_date - 10)
 @collection.save
end
 
Given(/^o limite de peso de residuos é "([^"]*)" kg$/) do |limit_weight|
 @collection = Collection.last
 @collection.max_value=limit_weight
 @collection.save
end

When(/^eu tento gerar a "([^"]*)"$/) do |action|
 if action == "Previsão de Notificação de Coleta"
  @collection = Collection.last
  @collection.generate_prediction
 end
end
 
Then(/^o sistema calcula a média de "([^"]*)" kg\/dia$/) do |mean|
 expect(@collection.mean).to eq(mean.to_f())
end
 
Then(/^o sistema calcula que faltam "([^"]*)" kg para atingir o limite$/) do |miss_weight|
  expect(miss_weight.to_f()).to eq(@collection.miss_weight)
end
 
Then(/^o sistema calcula que faltam "([^"]*)" dias para fazer a licitação$/) do |miss_days|
 expect(miss_days.to_i()).to eq(@collection.miss_days)
end

def cad_col(max_value)
 col = {collection: {max_value: max_value}}
 post '/collections', col
 return Collection.find_by(max_value: max_value)
end
 
def cad_dep(dep_name)
 dep = {department: {name: dep_name}}
 post '/departments', dep
 return Department.find_by(name: dep_name)
end
 
def cad_lab(lab_name, dep_id)
 lab = {laboratory: {name: lab_name, department_id: dep_id}}
 post '/laboratories', lab
 return Laboratory.find_by(name: lab_name)
end
 
def cad_res(res_name, lab_id,res_type)
 res = {residue: {name: res_name, kind: res_type, laboratory_id: lab_id}}
 post '/residues', res
 return Residue.find_by(name: res_name)
end

def cad_reg(weight, res_id)
 reg = {register: {weight: weight.to_f(), residue_id: res_id}}
 post '/registers', reg
 return Register.find_by(residue_id: res_id)
end

Given(/^existe "([^"]*)" kg de "([^"]*)" de tipo "([^"]*)" cadastrado no sistema$/) do |res_weight, res_name, res_type|
 if Collection.all.empty?
  col = cad_col(7500) 
  expect(col).to_not be nil
 end
 if Department.all.empty? 
  dep = cad_dep("Departamento de Genetica")
  expect(dep).to_not be nil
 end
 if Laboratory.all.empty?
  lab = cad_lab("Laboratorio de Genetica Aplicada", dep.id)
  expect(lab).to_not be nil
 end
 lab = Laboratory.find_by(name: "Laboratorio de Genetica Aplicada")
 res = cad_res(res_name,lab.id,res_type)
 expect(res).to_not be nil
 reg = cad_reg(res_weight.to_f(),res.id)
 expect(reg).to_not be nil
end
 
When(/^eu tento gerar o "([^"]*)"$/) do |action|
 if action == "Total de Resíduos Acumulados por Tipo"
  @collection = Collection.last
  @collection.type_residue
 end
end

Then(/^o sistema calcula o  "([^"]*)" com "([^"]*)" kg de substâncias de tipo "([^"]*)" e "([^"]*)" kg de substâncias de tipo "([^"]*)"$/) do |action,res_weight1,res_type1,res_weight2,res_type2|
 if action == "Total de Resíduos Acumulados por Tipo"
  validate(res_type1, res_weight1)
  validate(res_type2, res_weight2)
 end
end

def validate(res_type, res_weight)
 case res_type
 when "Sólido Orgânico"
  expect(@collection.solido_organico).to eq(res_weight.to_f())
 when "Sólido Inorgânico"
  expect(@collection.solido_inorganico).to eq(res_weight.to_f())
 when "Líquido Orgânico"
  expect(@collection.liquido_organico).to eq(res_weight.to_f())
 when "Líquido Inorgânico"
  expect(@collection.liquido_inorganico).to eq(res_weight.to_f())
 when "Líquido Inflamável"
  expect(@collection.liquido_inflamavel).to eq(res_weight.to_f())
 when "Outros"
  expect(@collection.outros).to eq(res_weight.to_f())
 end
 
end