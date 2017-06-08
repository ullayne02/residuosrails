@dep_name = ""
Given(/^o sistema possui o departamento de "([^"]*)" cadastrado$/) do |dep_name|
  dep = create_department({department: {name: dep_name}})
  expect(dep).to_not be nil
end

Given(/^o sistema possui o laboratório de "([^"]*)" cadastrado no departamento de "([^"]*)"$/) do |lab_name, dep_name|
  dep = Department.find_by(name: dep_name)
  expect(dep).to_not be nil
  lab = create_laboratory({laboratory: {name: lab_name, department_id: dep.id}})
 end 

Given(/^o sistema possui "([^"]*)"kg de resíduos cadastrados no laboratório de "([^"]*)"$/) do |res_weight, lab_name|
  lab = Laboratory.find_by(name: lab_name)
  expect(lab).to_not be nil
  res = create_residue({residue:{name: "Acido", laboratory_id: lab.id}})
  expect(res).to_not be nil
  create_register({register: {weight: res_weight.to_f(), residue_id: res.id}})
  reg = modify_date_last_register(res.id, "23/02/2017")
  expect(reg).to_not be nil
  expect(res.total_res).to eq(res_weight.to_f())
  end

When(/^eu tento produzir o relatório total de resíduos cadastrados entre as datas "([^"]*)" e "([^"]*)" para o departamento de "([^"]*)"$/) do |data_begin, data_final, dep_name|
    @dep_name = dep_name
  rep = {report: {
    generate_by: 1, 
    begin_dt: data_begin.to_date, 
    end_dt: data_final.to_date, 
    unit: false, 
    state: false, 
    kind: false, 
    onu: false, 
    blend: false, 
    code: false, 
    total: true,
    list: [dep_name]}
  }
  post '/reports', rep
  end

Then(/^o valor retornado pelo sistema será "([^"]*)"kg$/) do |res_weight|
  repc = Reportcell.where(dep_name: @dep_name)
  total = 0
  repc.each do |it|
    total += it.total
  end
  expect(total).to eq(res_weight.to_f())
end

Given(/^o sistema possui "([^"]*)" kg de resíduos cadastrados entre entre as datas "([^"]*)" e "([^"]*)" para o laboratorio de "([^"]*)"$/) do |res_weight, data_begin, data_final, lab_name|
    lab = Laboratory.find_by(name: lab_name)
	expect(lab).to_not be nil
	res = Residue.find_by(name:"Acido", laboratory_id: lab.id)
	if(res != nil) then
	  reg =create_register({register: {weight: res_weight.to_f(), residue_id: res.id}})
  else
    res = create_residue({residue: {name:"Acido", laboratory_id: lab.id}})
    reg = create_register({register: {weight: res_weight.to_f(), residue_id: res.id}})
    modify_date_last_register(res.id,data_begin)
  end
	expect(res).to_not be nil
	modify_date_last_register(res.id,data_begin)
	res = Residue.where(laboratory_id: lab.id)
  expect(res).to_not be nil
	sum_registers(res,data_begin,data_final)
  expect(sum_registers(res,data_begin,data_final)).to eq(res_weight.to_f())
end

Given(/^o sistema possui o departamento de "([^"]*)" cadastrado com o resíduo "([^"]*)" com quantidade total de "([^"]*)"Kg$/) do |dep_name, res_name, res_total|
  dep = create_department({department: {name: dep_name}})
  expect(dep).to_not be nil
  lab = create_laboratory({laboratory: {name: "lab_base: " + dep_name, department_id: dep.id}})
  expect(lab).to_not be nil
  res = create_residue({residue: {name: res_name, laboratory_id: lab.id}})
  expect(res).to_not be nil
  reg = create_register({register: {weight: res_total.to_f(), residue_id: res.id}})
  expect(reg.weight).to eq(res_total.to_f())
end

When(/^eu tento gerar um relatório dos resíduos dos departamentos de "([^"]*)", "([^"]*)" e "([^"]*)"$/) do |dep1, dep2, dep3|
  rep = {report: {
    generate_by: 1, 
    begin_dt: "01/01/2001".to_date, 
    end_dt: "29/12/2029".to_date, 
    unit: false, 
    state: false, 
    kind: false, 
    onu: false, 
    blend: false, 
    code: false, 
    total: true,
    list: [dep1, dep2, dep3]}
  }
  post '/reports', rep
end

Then(/^o sistema retorna o valor de "([^"]*)"Kg para o resíduo "([^"]*)"$/) do |res_weight, res_name|
  repc = Reportcell.where(res_name: res_name)
  total = 0
  repc.each do |it|
    total += it.total
  end
  expect(total).to eq(res_weight.to_f())
end

Given(/^o resíduo "([^"]*)" possui tipo como "([^"]*)", peso como "([^"]*)"Kg e código ONU como "([^"]*)" no laboratorio de "([^"]*)"$/) do |res_name, res_kind, res_weight, res_onu, lab_name|
  lab = Laboratory.find_by(name: lab_name)
  expect(lab).to_not be nil
  res = create_residue({residue: {name: res_name, kind: res_kind, onu: res_onu, laboratory_id: lab.id}})
  expect(res).to_not be nil
  reg = create_register({register: {weight: res_weight.to_f(), residue_id: res.id}})
  expect(reg.weight).to eq(res_weight.to_f())
end

When(/^eu tento produzir um relatório dos resíduos do laboratório de "([^"]*)", com os filtros tipo e peso\.$/) do |res|
  rep = {report: {
    generate_by: 2, 
    begin_dt: "01/01/2001".to_date, 
    end_dt: "29/12/2029".to_date, 
    unit: false, 
    state: false, 
    kind: true, 
    onu: false, 
    blend: false, 
    code: false, 
    total: true,
    list: [res]}
  }
  post '/reports', rep
end

Then(/^o sistema retorna as informações "([^"]*)" e "([^"]*)"Kg para o resíduo "([^"]*)"$/) do |kind, quant, res_name|
  repc = Reportcell.where(res_name: res_name)
  total = 0
  repc.each do |it|
    total += it.total
  end
  expect(total).to eq(quant.to_f())
  expect(repc[0].kind).to eq (kind)
end
##################################################GUI######################################################################

Given(/^que estou na página Geração de Relatórios/) do
   
    dep_name = "Departamento de Engenharia Química"
    lab_name = "Laboratório de Processos Químicos"
    res_name = "Hidróxido de Amônio"
    create_department_gui(dep_name)
    create_laboratory_gui(lab_name, dep_name)
    create_residue_gui(res_name, lab_name)
    create_register_gui(175.to_f(), res_name)
    res_name = "Sulfato de Amônio"
    create_residue_gui(res_name,lab_name)
    create_register_gui(100.to_f(), res_name)
    
    dep_name = "Departamento de Física"
    lab_name = "Laboratório de Análises"
    #create_department_gui(dep_name)
    #create_laboratory_gui(lab_name, dep_name)
    
   
  visit '/reports/new'
end

Given(/^a opção de gerar por "([^"]*)" está selecionada$/) do |arg1|
    if arg1 == "Departamento" then
      page.choose('rb1')
       choice = 'rb1'
    elsif arg1 == "Laboratório" then
      page.choose('rb2')
      choice = 'rb2'
    elsif arg1 == "Resíduo" then
      page.choose('rb3')
       choice = 'rb3'
    end
    expect(find_field(choice)).to be_checked
    
 
      
  
end

Given(/^eu vejo uma lista de "([^"]*)" disponíveis no sistema\.$/) do |arg1|
     if arg1 == "Departamentos" then
       choice = "rb1_list"
       
    elsif arg1 == "Laboratórios" then
       choice = "rb2_list"
       
    elsif arg1 == "Resíduos" then
       choice = "rb3_list"
     
    end
    expect(page.find(:id, 'report_list').visible?).to be true
    
end

Given(/^eu seleciono o "([^"]*)"$/) do |arg1|
     page.select arg1, :from => 'report_list'
     page.save_screenshot
end

Given(/^no campo data eu vejo "([^"]*)" para início  e "([^"]*)" para final\.$/) do |arg1, arg2|
  d = arg1.to_date
  ano = d.cwyear
  page.select ano, :from => 'report_begin_dt_1i'
  mes = d.strftime("%B")
  page.select mes, :from => 'report_begin_dt_2i'
  dia = d.wday
  page.select dia, :from => 'report_begin_dt_3i'
  
  d = arg2.to_date
  ano = d.cwyear
  page.select ano, :from => 'report_end_dt_1i'
  mes = d.strftime("%B")
  page.select mes, :from => 'report_end_dt_2i'
  dia = d.wday
  page.select dia, :from => 'report_end_dt_3i'
  
  
  
end

When(/^eu peço para Gerar Relatório$/) do 
  click_button 'Create Report'
end

When(/^eu vou para a página de resumo de sistema$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^eu devo visualizar a quantidade de resíduos produzidos, associado ao "([^"]*)" entre as datas  "([^"]*)" e  "([^"]*)"$/) do |arg1, arg2, arg3|
  pending # Write code here that turns the phrase above into concrete actions
end


def sum_registers(res,data_begin,data_final)
   residues_total_in_data = 0
     res.each do |it|
	    rList = it.registers.where(created_at:[data_begin.to_date..data_final.to_date])
	    
      expect(rList).to_not be nil
      residues_total_in_data = residues_total_in_data + rList.sum(:weight)
    end
     residues_total_in_data
end

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

def modify_date_last_register(res_id, date)
  reg = Residue.find(res_id).registers.last
  reg.created_at = date.to_date
  reg.save
end

def create_department_gui(arg1)
  visit '/departments/new'
  fill_in('department_name', :with => arg1)
  click_button 'Create Department'
 
end

def create_laboratory_gui(arg1, arg2)
  visit '/laboratories/new'
  fill_in('laboratory_name', :with => arg1)
  page.select arg2, :from => 'laboratory_department_id'
  click_button 'Create Laboratory'
  
end

def create_residue_gui(arg1, arg2)
  visit '/residues/new'
  fill_in('residue_name', :with => arg1)
  page.select arg2, :from => 'residue_laboratory_id'
  click_button 'Create Residue'
end

def create_register_gui(arg1, arg2)
  visit '/registers/new'
  fill_in('register_weight', :with => arg1)
  page.select arg2, :from => 'register_residue_id'
  click_button 'Create Register'
end

def destroy_all
    Department.all.each do |it|
      it.destroy
    end
    Laboratory.all.each do |it|
      it.destroy
    end
    Residue.all.each do |it|
      it.destroy
    end
    Register.all.each do |it|
      it.destroy
    end
  end

  
  
  
  

