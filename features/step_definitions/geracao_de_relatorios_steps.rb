Given(/^o sistema possui o departamento de "([^"]*)" cadastrado$/) do |dep_name|
  dep = createDepartment({department: {name: dep_name}})
  expect(dep).to_not be nil
end

Given(/^o sistema possui o laboratório de "([^"]*)" cadastrado no departamento de "([^"]*)"$/) do |lab_name, dep_name|
  dep = Department.find_by(name: dep_name)
  expect(dep).to_not be nil
  lab = createLaboratory({laboratory: {name: lab_name, department_id: dep.id}})
 end 

Given(/^o sistema possui "([^"]*)"kg de resíduos cadastrados no laboratório de "([^"]*)"$/) do |res_weight, lab_name|
  lab = Laboratory.find_by(name: lab_name)
  expect(lab).to_not be nil
  res = createResidue({residue:{name: "Acido", laboratory_id: lab.id}})
  expect(res).to_not be nil
  createRegister({register: {weight: res_weight.to_f(), residue_id: res.id}})
  reg = modifyDateLastRegister(res.id, "23/02/2017")
  expect(reg).to_not be nil
  expect(res.total_res).to eq(res_weight.to_f())
  end

When(/^eu tento produzir o relatório total de resíduos cadastrados entre as datas "([^"]*)" e "([^"]*)" para o departamento de "([^"]*)"$/) do |data_begin, data_final, dep_name|
 
  dep = (Department.find_by(name: dep_name))
  expect(dep).to_not be nil
  value_total = 0
  Laboratory.where(department_id: dep.id).each do |it|
      p it.total_lab  
      value_total = value_total + it.total_lab.to_f()
  end
  p value_total
  
  end

Then(/^o valor retornado pelo sistema será "([^"]*)"kg$/) do |res_weight|
  expect(@value_test).to eq(res_weight.to_f())
end

Given(/^o sistema possui "([^"]*)" kg de resíduos cadastrados entre entre as datas "([^"]*)" e "([^"]*)" para o laboratorio de "([^"]*)"$/) do |res_weight, data_begin, data_final, lab_name|
  lab = Laboratory.find_by(name: lab_name)
	expect(lab).to_not be nil
	res = Residue.find_by(name:"Acido", laboratory_id: lab.id)
	if(res != nil) then
	  reg = {register: {weight: res_weight.to_f(), residue_id: res.id}}
  else
    res = createResidue({residue: {name:"Acido", laboratory_id: lab.id}})
    modifyDateLastRegister(res_id,data_begin.to_date)
    put_date(res,data_begin.to_date)
    reg = {register: {weight: res_weight.to_f(), residue_id: res.id}}
  end
	expect(res).to_not be nil
	post '/update_weight', reg

	modifyDateLastRegister(res_id,data_begin.to_date)
	res = Residue.where(laboratory_id: lab.id)
  expect(res).to_not be nil
	sum_registers(res,data_begin,data_final)
  expect(@value_test).to eq(res_weight.to_f())
  p res.total.eql?(res_weight)

end

Given(/^o sistema possui o departamento de "([^"]*)" cadastrado com o resíduo "([^"]*)" com quantidade total de "([^"]*)"Kg$/) do |dep_name, res_name, res_total|
  dep = createDepartment({department: {name: dep_name}})
  expect(dep).to_not be nil
  lab = createLaboratory({laboratory: {name: "lab_base: " + dep_name, department_id: dep.id}})
  expect(lab).to_not be nil
  res = createResidue({residue: {name: res_name, laboratory_id: lab.id}})
  expect(res).to_not be nil
  reg = createRegister({register: {weight: res_total.to_f(), residue_id: res.id}})
  expect(reg.weight).to eq(res_total.to_f())
end

When(/^eu tento gerar um relatório dos resíduos dos departamentos de "([^"]*)", "([^"]*)" e "([^"]*)"$/) do |dep1, dep2, dep3|
  dep1_id = Department.find_by(name: dep1).id
  dep2_id = Department.find_by(name: dep2).id
  dep3_id = Department.find_by(name: dep3).id
  rep = {report: {
    generate_by: 1, 
    begin_date: "01/01/2001".to_date, 
    end_date: "29/12/2029".to_date, 
    unit: false, 
    state: false, 
    kind: false, 
    onu: false, 
    blend: false, 
    code: false, 
    total: true,
    list: [dep1_id, dep2_id, dep3_id]
  }}
  post '/reports', rep
end

Then(/^o sistema retorna o valor de "([^"]*)"Kg para o resíduo "([^"]*)"$/) do |arg1, arg2|
  repc = Reportcell.where(res_name: arg2)
  total = 0
  repc.each do |it|
    total += it.total
  end
  expect(total).to eq(arg1.to_f())
end

Given(/^o resíduo "([^"]*)" possui tipo como "([^"]*)", peso como "([^"]*)"Kg e código ONU como "([^"]*)" no laboratorio de "([^"]*)"$/) do |res_name, res_kind, res_weight, res_onu, lab_name|
  lab = Laboratory.find_by(name: lab_name)
  expect(lab).to_not be nil
  res = {residue: {name: res_name, kind: res_kind, onu: res_onu, laboratory_id: lab.id}}
  post '/residues', res
  res = Residue.find_by(name: res_name, laboratory_id: lab.id)
  expect(res).to_not be nil
  reg = {register: {weight: res_weight.to_f(), residue_id: res.id, department_id: lab.department_id, laboratory_id: lab.id}}
  post '/update_weight', reg
  reg = res.registers.last
  expect(reg.weight).to eq(res_weight.to_f())
end

When(/^eu tento produzir um relatório dos resíduos do laboratório de "([^"]*)", com os filtros tipo e peso\.$/) do |arg1|
  rep = {report: {generate_by: 2, begin_date: "01/01/2001".to_date, end_date: "29/12/2029".to_date, f_unit: false, f_state: false, f_kind: true, f_onu: false, f_blend: false, f_code: false, f_total: true}}
  post '/reports', rep
  repc = {reportcell: {lab_name: arg1}}
  post '/generate_reportcell', repc
end

Then(/^o sistema retorna as informações "([^"]*)" e "([^"]*)"Kg para o resíduo "([^"]*)"$/) do |arg1, arg2, arg3|
  repc = Reportcell.where(res_name: arg3)
  total = 0
  repc.each do |it|
    total += it.total
  end
  expect(total).to eq(arg2.to_f())
  expect(repc[0].kind).to eq (arg1)
end


def sum_registers(res,data_begin,data_final)
     residues_total_in_data = 0
     res.each do |it|
	    rList = it.registers.where(created_at: [data_begin.to_date..data_final.to_date])
      expect(rList).to_not be nil
      r = rList.order(:created_at)
     
      residues_total_in_data = residues_total_in_data + (rList.last.weight - rList.first.weight)
    end
   residues_total_in_data
end
  


def createDepartment(dep)
  post '/departments', dep
  Department.find_by(name: dep[:department][:name])
end

def createLaboratory(lab)
  post '/laboratories', lab
  Laboratory.find_by(name: lab[:laboratory][:name], department_id: lab[:laboratory][:department_id])
end

def createResidue(res)
  post '/residues', res
  Residue.find_by(name: res[:residue][:name], laboratory_id: res[:residue][:laboratory_id])
end

def createRegister(reg)
  post '/registers', reg
  Residue.find(reg[:register][:residue_id]).registers.last
end

def modifyDateLastRegister(res_id, date)
  reg = Residue.find(res_id).registers.last
  reg.created_at = date.to_date
  reg.save
  reg
end

