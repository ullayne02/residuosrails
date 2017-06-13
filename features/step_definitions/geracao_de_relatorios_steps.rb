
  Given(/^o sistema possui o departamento de "([^"]*)" cadastrado$/) do |dep_name|
    dep = create_department({department: {name: dep_name}})
    expect(dep).to_not be nil
   
  end
  
  Given(/^o sistema possui o laboratório de "([^"]*)" cadastrado no departamento de "([^"]*)"$/) do |lab_name, dep_name|
    dep = Department.find_by(name: dep_name)
    expect(dep).to_not be nil
    lab = create_laboratory({laboratory: {name: lab_name, department_id: dep.id}})
    expect(lab).to_not be nil
  end 
  
  Given(/^o sistema possui "([^"]*)"kg de resíduos cadastrados no laboratório de "([^"]*)"$/) do |res_weight, lab_name|
    lab = Laboratory.find_by(name: lab_name)
    expect(lab).to_not be nil
    res = create_residue({residue:{name: "Acido", laboratory_id: lab.id}})
    expect(res).to_not be nil
    create_register({register: {weight: res_weight.to_f(), residue_id: res.id}})
    reg = modify_date_last_register(res.id, "23/02/2017")
    expect(reg).to_not be nil
    expect(res.weight).to eq(res_weight.to_f())
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
    expect(sum_registers(res,data_begin,data_final)).to eq(res_weight.to_f())
  end
  
  Given(/^o sistema possui o departamento de "([^"]*)" cadastrado com o resíduo "([^"]*)" com quantidade total de "([^"]*)"Kg$/) do |dep_name, res_name, res_total|
    dep = create_department({department: {name: dep_name}})
    expect(dep).to_not be nil
    lab = create_laboratory({laboratory: {name: "lab_base: " + dep_name, department_id: dep.id}})
    expect(lab).to_not be nil
    res = create_residue({residue: {name: res_name, laboratory_id: lab.id, collection_id: (Collection.last != nil ? Collection.last.id : nil)}})
    expect(res).to_not be nil
    reg = create_register({register: {weight: res_total.to_f(), residue_id: res.id}})
    expect(reg.weight).to eq(res_total.to_f())
  end
  
  When(/^eu tento gerar um relatório dos resíduos dos departamentos de "([^"]*)", "([^"]*)" e "([^"]*)"$/) do |dep1, dep2, dep3|
    rep = {report: {
      generate_by: 1, 
      begin_dt: (Time.now.to_date - 1), 
      end_dt: (Time.now.to_date + 1),  
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
      begin_dt: (Time.now.to_date - 1), 
      end_dt: (Time.now.to_date + 1), 
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
  
  Given(/^o sistema possui "([^"]*)" kg de "([^"]*)" cadastrados para o laboratorio de "([^"]*)"$/) do |res_weight, res_name, lab_name|
    
    lab = Laboratory.find_by(name: lab_name)
    expect(lab).to_not be nil
    res = create_residue({residue: {name: res_name, laboratory_id: lab.id}})
    expect(res).to_not be nil
    reg = create_register({register: {weight: res_weight.to_f(), residue_id: res.id}})
    expect(reg).to_not be nil
    modify_date_last_register(res.id, Time.now.to_date-1)
    expect(reg.weight).to eq(res_weight.to_f())
  end
  
  When(/^eu tento produzir o relatório para o Laboratório de "([^"]*)"$/) do |lab_name|
      @lab_name = lab_name
      rep = {report: {
      generate_by: 2, 
      begin_dt: "11/06/2017".to_date, 
      end_dt: Time.now.to_date+1, 
      unit: false, 
      state: false, 
      kind: false, 
      onu: false, 
      blend: false, 
      code: false, 
      total: true,
      list: [lab_name]}
    }
    post '/reports', rep
   
  end
  
  Then(/^o valor retornado pelo sistema será "([^"]*)" kg referente ao Resíduo com maior registro$/) do |res_weight|
    repc = Reportcell.where(lab_name: @lab_name)
    total = 0
    repc.each do |it|
      if total < it.total then
        it.total
        total = it.total
      end
    end
    expect(total.to_f()).to eq(res_weight.to_f())
    expect(heaviest_res(@lab_name).to_f()).to eq(res_weight.to_f())
  
  end
  ##################################################GUI######################################################################
 
  Given(/^eu possuo "([^"]*)" kg de resíduos cadastrados entre as datas  "([^"]*)" e  "([^"]*)"$/) do |res_weight, data_begin,data_final|
   
      dep_name = "Engenharia Química"
      lab_name = "Processos Químicos"
      res_name = "Hidróxido de Amônio"
      
      create_department_gui(dep_name)
      create_laboratory_gui(lab_name, dep_name)
      create_residue_gui(res_name, lab_name)
      create_register_gui(res_weight.to_f(), res_name)
      
      lab = Laboratory.find_by(name: lab_name)
      res = Residue.find_by(name: res_name, laboratory_id: lab.id)
      
      modify_date_last_register(res, data_begin)
      res_name = "Sulfato de Amônio"
      create_residue_gui(res_name,lab_name)
      create_register_gui(100.to_f(), res_name)     
  end
  
  Given(/^que estou na página Geração de Relatórios$/) do
      visit '/reports/new'
  end
  
  Given(/^a opção de gerar por "([^"]*)" está selecionada$/) do |option|
      if option == "Coleta" then
        page.find(:id, 'rb0').trigger('click')
        choice = 'rb0'
      elsif option == "Departamento" then
       page.find(:id, 'rb1').trigger('click')
         choice = 'rb1'
      elsif option == "Laboratório" then
       page.find(:id, 'rb2').trigger('click')
        choice = 'rb2'
      elsif option == "Resíduo" then
        page.find(:id, 'rb3').trigger('click')
         choice = 'rb3'
      end
      expect(find_field(choice)).to be_checked
     
  end
  Given(/^eu seleciono o filtro "([^"]*)"$/) do |option|
      if option == "total"
        page.find(:checkbox, 'report_total').trigger('click')
      elsif option == "codigo"
       page.find(:checkbox, 'report_code').trigger('click')
      elsif option == "composição"
       page.find(:checkbox, 'report_blend').trigger('click')
      elsif option == "onu"
       page.find(:checkbox, 'report_onu').trigger('click')
      elsif option == "tipo"
        page.find(:checkbox, 'report_kind').trigger('click')
      elsif option == "estado"
        page.find(:checkbox, 'report_state').trigger('click')
      elsif option == "unidade"
        page.find(:checkbox, 'report_unit').trigger('click')
      end
      
  end
  
  Given(/^eu vejo uma lista de "([^"]*)" disponíveis no sistema$/) do |option|
      choice = nil
      if("Departamentos" == option) then
        choice = "rb1_list"
      elsif("Laboratórios" == option) then
        choice = "rb2_list"
      elsif("Resíduos" == option) then
        choice = "rb3_list"
      end
      expect(page.find(:id, choice).visible?).to be true
  end
  
  Given(/^eu seleciono a opção "([^"]*)" na lista$/) do |option|
    page.select option, :from => 'report_list'
  end
  
  Given(/^no campo data eu vejo "([^"]*)" para início  e "([^"]*)" para final\.$/) do |data_begin, data_final|
    put_data_begin_gui(data_begin.to_date,data_final.to_date)
    
  end
  
  When(/^eu peço para Gerar Relatório$/) do 
    
    click_button 'Create Report'
  end
  
  When(/^eu vou para a página de resumo de sistema$/) do
     expect(page).to have_content "Relatório de " 
  end
  
  Then(/^eu devo visualizar "([^"]*)" de resíduos produzidos, associado a "([^"]*)" entre as datas  "([^"]*)" e  "([^"]*)"$/) do |res_weight, name, data_begin,data_final|
    expect(page).to have_content res_weight 
    
  end

  Given(/^que foi feito o cadastro do laboratório de "([^"]*)" com o resíduo "([^"]*)" onde o tipo é "([^"]*)" e a quantidade total é "([^"]*)"Kg$/) do |lab_name, res_name, kind, total|
    create_department_gui("dep base: " + lab_name);
    create_laboratory_gui(lab_name, "dep base: " + lab_name);
    visit '/residues/new'
    fill_in('residue_name', :with => res_name)
    page.select kind, :from => 'residue_kind'
    page.select lab_name, :from => 'residue_laboratory_id'
    click_button 'Create Residue'
    create_register_gui(total, res_name)
  end
  
  Given(/^que estou na página de Geração de Relatórios$/) do
    visit '/reports/new'
    #garante que na pagina visitada existe um intervalo minino valido para gerar um laboratorio
    select (Time.now.year()-1), :from => 'report_begin_dt_1i'
    select (Time.now.year()+1), :from => 'report_end_dt_1i'
  end
  
  When(/^peço para criar um novo relátorio$/) do
    click_button 'Create Report'
  end
  
  Then(/^sou redirecionado para a página do relatório de "([^"]*)"$/) do |generate_by|
    expect(page).to have_content "Relatório de "+generate_by
  end
  
  Then(/^vejo uma tabela com os dados sobre o Laboratório de "([^"]*)" contendo nome, tipo e quantidade total dos resíduos$/) do |lab_name|
    expect(page.find('table').visible?).to be true
    expect(page.find('td', text: lab_name).visible?).to be true
    expect(page.find('th', text: 'Nome do res.').visible?).to be true
    expect(page.find('th', text: 'Tipo').visible?).to be true
    expect(page.find('th', text: 'Total (peso)').visible?).to be true
  end
  
  Then(/^vejo na coluna nome do residuo "([^"]*)", na coluna tipo "([^"]*)" e na coluna quantidade total "([^"]*)"Kg\.$/) do |res_name, kind, total|
    expect(page.find('tr', text: res_name).find('td', text: res_name).visible?).to be true
    expect(page.find('tr', text: res_name).find('td', text: kind).visible?).to be true
    expect(page.find('tr', text: res_name).find('td', text: total).visible?).to be true
  end
  
  Given(/^que foi feito o cadastro do departamento de "([^"]*)" sem nenhum residuo cadastrado$/) do |dep_name|
    create_department_gui(dep_name)
  end
  
  Then(/^eu vejo uma mensagem de notificação informando a inexistência de resíduos ligados aos departamentos.$/) do
    div_error = page.find('div', id: 'error_explanation')
    expect(div_error.visible?).to be true
    expect(div_error).to have_content "Não há residuos associados a esse(s) departamento(s)/laboratório(s)!"
  end
  
  Given(/^o sistema possui uma coleta corrente com "([^"]*)"Kg de limite de peso$/) do |max_value|
    col = create_collection({collection: {max_value: max_value}})
    expect(col).to_not be nil
  end
  
  When(/^eu tento gerar um relatório da última coleta corrente$/) do
    rep = {report: {
      generate_by: 0, 
      begin_dt: (Time.now.to_date - 1), 
      end_dt: (Time.now.to_date + 1), 
      unit: false, 
      state: false, 
      kind: false, 
      onu: false, 
      blend: false, 
      code: false, 
      total: true,}
    }
    post '/reports', rep
  end
  
 Given(/^eu possuo "([^"]*)" cadastrado em "([^"]*)"$/) do |option, option1|
   create_department_gui("Qualquer")
   create_laboratory_gui(option1,"Qualquer")
   create_residue_gui(option,option1)
end 

Given(/^no campo filtros eu não seleciono nenhum filtro$/) do
 
 find(:css, "#report_unit,report_state,report_kind,report_onu,report_blend, report_code,report_total[value='1']").set(false)

end

Then(/^eu devo visualizar "([^"]*)" na lista com os nomes de resíduos associados a "([^"]*)"$/) do |option, option1|
  expect(page).to have_content option
  expect(page).to have_content option1 
 
end
  
  
  When(/^eu tento produzir um relatório do resíduo "([^"]*)"$/) do |res_name|
    rep = {report: {
      generate_by: 3, 
      begin_dt: (Time.now.to_date - 1), 
      end_dt: (Time.now.to_date + 1), 
      unit: false, 
      state: false, 
      kind: false, 
      onu: false, 
      blend: false, 
      code: false, 
      total: true,
      list: [res_name]
      }
    }
    post '/reports', rep
  end

  Then(/^o sistema retorna o valor de "([^"]*)"Kg para o resíduo "([^"]*)" em uma única célula$/) do |quant, res_name|
    repc = Reportcell.find_by(res_name: res_name)
    expect(repc.total).to eq(quant.to_f())
  end
  
  Given(/^que foi feito o cadastro do departamento de "([^"]*)" com o resíduo "([^"]*)" e a quantidade total é "([^"]*)"Kg$/) do |dep_name, res_name, total|
    create_department_gui(dep_name)
    create_laboratory_gui("lab base: " + dep_name, dep_name)
    create_residue_gui(res_name, "lab base: " + dep_name)
    create_register_gui(total.to_f(), res_name)
  end
  
  Then(/^vejo uma tabela com os dados sobre os departamento contendo nome do departamento, nome do residuo e quantidade total do resíduo$/) do
    expect(page.find('table').visible?).to be true
    expect(page.find('th', text: 'Nome do dep.').visible?).to be true
    expect(page.find('th', text: 'Nome do res.').visible?).to be true
    expect(page.find('th', text: 'Total (peso)').visible?).to be true
  end
  
  Then(/^vejo em uma coluna o nome do departamento com "([^"]*)", o nome do residuo com "([^"]*)" e a quantidade total com "([^"]*)"Kg\.$/) do |dep_name, res_name, total|
    expect(page.find('tr', text: res_name).find('td', text: res_name).visible?).to be true
    expect(page.find('tr', text: res_name).find('td', text: dep_name).visible?).to be true
    expect(page.find('tr', text: res_name).find('td', text: total).visible?).to be true
  end

  Then(/^eu vejo uma mensagem de notificação informando que a data e hora do inicio esta posterior ou iqual a data e hora do final do intervalo requerido\.$/) do
    div_error = page.find('div', id: 'error_explanation')
    expect(div_error.visible?).to be true
    expect(div_error).to have_content "intervalo de data invalido: a data e hora de inicio esta posterior ou iqual a data e hora de final do intervalo requerido."
  end
  
  Given(/^que possuo uma coleta com limite de peso "([^"]*)"$/) do |col_weight|
    create_collection_gui(col_weight)
  end
  Given(/^eu possuo o resíduo "([^"]*)" associado a coleta$/) do |res_name|
      dep_name = "Engenharia Química"
      lab_name = "Processos Químicos"
      create_department_gui(dep_name)
      create_laboratory_gui(lab_name, dep_name)
      create_residue_gui(res_name, lab_name)           #Por padrão um residuo é automaticamente na coleta mais recente
      create_register_gui(200.to_f(), res_name)
  end
  
  Then(/^eu devo visualizar uma tabela com os nomes de resíduos associados a coleta$/) do
    expect(page.find('table').visible?).to be true
    
  end
  
  Then(/^eu devo visualizar "([^"]*)" em uma linha da tabela$/) do |option|
    expect(page.find('td', text: option).visible?).to be true
end
  
#####################################Funções#############################################################################################  
  
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
  
  def create_collection(col)
    post '/collections', col
    Collection.last
  end
  
  def modify_date_last_register(res_id, date)          #Modifica o ultimo registro de um dado residuo, usado nos cenarios de controlador
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
  
  def create_collection_gui(arg1)
    visit '/collections/new'
    fill_in('collection_max_value', :with => arg1)
    click_button 'Create Collection'
  end
  
  
  def put_data_begin_gui(data_begin,data_final)                           #coloca as datas nos campos de data na gui
    
    page.select data_begin.cwyear, :from => 'report_begin_dt_1i'
    page.select data_begin.strftime("%B"), :from => 'report_begin_dt_2i'
    page.select data_begin.wday, :from => 'report_begin_dt_3i'
    
    page.select data_final.cwyear, :from => 'report_end_dt_1i'
    page.select data_final.strftime("%B"), :from => 'report_end_dt_2i'
    page.select data_final.wday, :from => 'report_end_dt_3i'
    
  end
  
  def heaviest_res(lab_name)                                #Calcula o residuo de maior registro para comparação
     lab = Laboratory.find_by(name: lab_name)
      expect(lab).to_not be nil
      res = Residue.where(laboratory_id: lab.id)
      heaviest = 0
      res.each do |it|
        if heaviest < it.registers.sum(:weight) then
          heaviest = it.registers.sum(:weight)
         
        end
      end
      heaviest
  end
    
  
  
  
    
    
    
    
  
