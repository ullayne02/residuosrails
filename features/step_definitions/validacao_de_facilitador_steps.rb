@user = nil 
Given(/^que o facilitador de login "([^"]*)" não está associado a nenhum laboratório$/) do |fac_name|
    
    @user = create_user({user: {name: fac_name, email: "abc@abc.com", password: "123", kind: "fac"}})
    expect(@user).to_not be nil

end
Given(/^o laboratorio "([^"]*)" nao possui nenhum facilitadro associado a ele$/) do |lab_name|
    
    dep_name = "cin"
   
    dep = create_department({department: {name: dep_name}})
    expect(dep).to_not be nil
    
    lab = create_laboratory({laboratory: {name: lab_name, department_id: dep.id}})
    expect(lab).to_not be nil
end

When(/^o sistema verifica se o facilitador "([^"]*)" está associado a um laboratório\.$/) do |fac_name|
    
    user = User.find_by(name: fac_name)
    expect(user).to_not be nil
    
    lab = Laboratory.find_by(user_id: user.id)
    expect(lab).to_not be !nil

end

Then(/^o sistema faz a requisicao do facilitador "([^"]*)" ao laboratorio "([^"]*)"$/) do |fac_name, lab_name|
    
    user = User.find_by(name: fac_name)
    expect(user).to_not be nil

    lab = Laboratory.find_by(name: lab_name)
    expect(lab).to_not be nil
    
    req = create_request({request: {user_id: user.id, laboratory_id: lab.id}})
    expect(req).to_not be nil

end
Given(/^o adm "([^"]*)" esta asscoiado ao sistema$/) do |adm_name|
    
    user = create_user({user: {name: adm_name, email: "adc@abc.com", password: "123", kind: "adm"}})
    expect(user).to_not be nil
  
end

When(/^o facilitador "([^"]*)" faz uma requisicao de acesso para o laboratorio "([^"]*)"$/) do |fac_name, lab_name|
    
    dep_name = "cin"
    dep = create_department({department: {name: dep_name}})
    expect(dep).to_not be nil
    
    lab = create_laboratory({laboratory: {name: lab_name, department_id: dep.id}})
    expect(lab).to_not be nil
    
    user = create_user({user: {name: fac_name, email: "def@abc.com", password: "123", kind: "fac"}})
    expect(user).to_not be nil
end

Then(/^o sistema faz uma notificacao avisando que o facilitador "([^"]*)" fez uma requisicao para o laboratorio "([^"]*)"$/) do |fac_name, lab_name|
    
    fac = User.find_by(name: fac_name)
    expect(fac).to_not be nil
    
    lab = Laboratory.find_by(name: lab_name)
    expect(lab).to_not be nil
    
    req = Request.find_by(user_id: fac.id)
    expect(req).to_not be nil
    
    noti = create_notification({notification: {message: "Nova requisicao", request_id: req.id}})
    expect(noti).to_not be nil
end

########## CENARIOS DE GUI

@req = nil

Given(/^eu estou na pagina de requisicoes$/) do
    visit '/requests'
end

Given(/^existe uma requisicao pendente$/) do
    
    create_user_gui("lar", "z@cin.ifpe.br", "123", "fac")
    create_department_gui("cin")
    create_laboratory_gui("grad1", "cin")
    create_request_gui("lar", "grad1")
    
end

When(/^eu clico em aceitar$/) do
    click_on('Aceitar')   

end

Then(/^eu vejo que a requisicao nao aparece mais$/) do
    expect(page).to_not have_content @req[:user_name]
end

Given(/^o facilitador "([^"]*)" esta associado ao laboratorio de "([^"]*)"$/) do |fac_name, lab_name|
    
    create_user_gui(fac_name, "a@cin.ifpe.br", "123", "fac")
    create_department_gui("cin")
    create_laboratory_gui(lab_name, "cin")
    create_request_gui(fac_name,lab_name)
    visit '/requests'
    click_on('Aceitar')   

end

When(/^o facilitador "([^"]*)" faz uma requisição de acesso para o laboratório "([^"]*)"$/) do |fac_name, lab_name|
    
    visit 'laboratories/new'
    fill_in('laboratory_name', :with => lab_name)
    page.select "cin", :from => 'laboratory_department_id'
    click_button 'Create Laboratory'
    
    visit 'requests/new'
    page.select fac_name, :from => 'request_user_id'
    page.select lab_name, :from => 'request_laboratory_id'
    click_button 'Create Request'
    
end

Then(/^eu vejo uma mensagem informando que o facilitador "([^"]*)" ja esta associado a um laboratório$/) do |fac_name|
    visit '/main_adm'
    element = find("td", text:"Facilitador " + fac_name + " ja esta associado a um laboratorio")
    expect(element).to_not be nil
    
end

###############################Cenarios @d5-d8####################################

###CONTROLADOR

Given(/^o administrador "([^"]*)" esta associado ao sistema$/) do |adm_name|
    param_adm = {user: {name: adm_name, email: "uffl@cin.ufpe.br", password: "adc", kind: "adm"}}
    post '/users', param_adm
    adm = User.find_by(name: adm_name)
    expect(adm).to_not be nil
end

Given(/^o laboratorio "([^"]*)" esta associado ao sistema$/) do |lab_name|
    param_lab = {laboratory: {name: lab_name, department: nil}}
    post '/laboratories', param_lab
    p_lab = Laboratory.find_by(name: lab_name)
    expect(p_lab).to_not be nil
end

@req = nil 
When(/^o administrador "([^"]*)" pede acesso ao laboratório "([^"]*)"$/) do |adm_name, lab_name|
    
    adm = User.find_by(name: adm_name)
    lab = Laboratory.find_by(name: lab_name)
    
    param_req = {request: {user_id: adm.id, laboratory_id: lab.id}}
    post '/requests', param_req
    @req = Request.find_by(user_id: adm.id)
    
    
end

Then(/^o sistema gera uma notificacao avisando que o administrador nao pode pedir acesso a laboratorio$/) do
  
    param_not = {notification: {message: "Um administrador nao pode se associar a um laboratorio",request_id: @req.id}}
    post '/notifications', param_not
    noti = Notification.find_by(request_id: @req.id)
    expect(noti).to_not be nil
    
end

#####Gui

Given(/^estou na pagina de administrador$/) do
  visit '/main_adm'
end

When(/^eu vejo que o facilitador "([^"]*)" fez uma requisicao ao laboratorio "([^"]*)"$/) do |fac_name, lab_name|
    
    visit 'users/new'
    fill_in('user_name', :with => fac_name)
    fill_in('user_email', :with => "joc@cin.ufpe.br")
    fill_in('user_password', :with => "111")
    fill_in('user_kind', :with => "fac")
    click_button 'Create User'
    
     
    visit 'departments/new'
    fill_in('department_name', :with => "cin")
    click_button 'Create Department'
    
    visit 'laboratories/new'
    fill_in('laboratory_name', :with => lab_name)
    page.select "cin", :from => 'laboratory_department_id'
    click_button 'Create Laboratory'
    
    visit 'requests/new'
    page.select fac_name, :from => 'request_user_id'
    page.select lab_name, :from => 'request_laboratory_id'
    click_button 'Create Request'
    
    expect(page).to have_content fac_name 
    expect(page).to have_content lab_name

    visit '/requests'
    
    
end
Then(/^o mostra uma notificacao avisando que o facilitador "([^"]*)" fez uma requisicao para o laboratorio "([^"]*)"$/) do |fac_name, lab_name|
    visit '/main_adm'
    element = find("td", text:"Facilitador " + fac_name + " fez um pedido de acesso ao laboratorio " + lab_name)
    expect(element).to_not be nil
end

Given(/^o facilitador "([^"]*)" esta associado ao laboratorio "([^"]*)"$/) do |fac_name, lab_name|
    param_fac = {user: {name: fac_name, email: "uffl@cin.ufpe.br", password: "adc", kind: "fac"}}
    post '/users', param_fac
    p param_fac
    fac = User.find_by(name: fac_name)
    expect(fac).to_not be nil
    
    param_lab = {laboratory: {name: lab_name, department: nil}}
    post '/laboratories', param_lab
    p_lab = Laboratory.find_by(name: lab_name)
    expect(p_lab).to_not be nil
    
    param_req = {request: {user_id: fac.id, laboratory_id: p_lab.id}}
    post '/requests', param_req
    p_req = Request.find_by(user_id: fac.id)
    #tirar de comentario quando de merge com jonatas
    post 'accept_request', :request => p_req.id
    
end

@request = nil 
When(/^o facilitador "([^"]*)" faz requisicao de acesso ao laboratorio "([^"]*)"$/) do |fac_name, lab_name|
  param_fac = {user: {name: fac_name, email: "uffl@cin.ufpe.br", password: "adc", kind: "fac"}}
    post '/users', param_fac
    p param_fac
    fac = User.find_by(name: fac_name)
    expect(fac).to_not be nil
    
    param_lab = {laboratory: {name: lab_name, department: nil}}
    post '/laboratories', param_lab
    p_lab = Laboratory.find_by(name: lab_name)
    expect(p_lab).to_not be nil
    
    param_req = {request: {user_id: fac.id, laboratory_id: p_lab.id}}
    post '/requests', param_req
    @request = Request.find_by(user_id: fac.id)
    
    expect(@request).to_not be nil
end

Then(/^o sistema gera uma notificacao informando que o facilitador "([^"]*)" nao pode se associar a mais de um laboratorio$/) do |lab_name|
    
    param_not = {notification: {message: "Nova requisicao",request_id: @request.id}}
    post '/notifications', param_not
    noti = Notification.find_by(request_id: @request.id)
    expect(noti).to_not be nil
    
end

#################################FUNCOES#################################

def create_user (user)
    post '/users', user
    User.find_by(name: user[:user][:name])
end

def create_department(dep)
    post '/departments', dep
    Department.find_by(name: dep[:department][:name])
end

def create_laboratory(lab)
    post '/laboratories', lab
    Laboratory.find_by(name: lab[:laboratory][:name], department_id: lab[:laboratory][:department_id])
end

def create_request(req)
    post '/requests', req
    Request.find_by(laboratory_id: req[:request][:laboratory_id])
end

def create_notification(noti)
   post '/notifications', noti
   Notification.find_by(request_id: noti[:notification][:request_id])
end

def create_department_gui(dep_name)
    visit '/departments/new'
    fill_in('department_name', :with => dep_name)
    click_button 'Create Department'
end

def create_laboratory_gui(lab_name, dep_name)
  visit '/laboratories/new'
  fill_in('laboratory_name', :with => lab_name)
  page.select dep_name, :from => 'laboratory_department_id'
  click_button 'Create Laboratory'
end

def create_user_gui(user_name, user_email, password, kind)
    visit 'users/new'
    fill_in('user_name', :with => user_name)
    fill_in('user_email', :with => user_email)
    fill_in('user_password', :with => password)
    fill_in('user_kind', :with => kind)
    click_button 'Create User'
end

def create_request_gui(fac_name, lab_name)
    visit 'requests/new'
    req = {user_name: fac_name, lab_name: lab_name}
    page.select fac_name, :from => 'request_user_id'
    page.select lab_name, :from => 'request_laboratory_id'
    click_button 'Create Request'
    visit '/requests'
end