Given(/^que o facilitador de login "([^"]*)" não está associado a nenhum laboratório$/) do |fac_name|
    
    param_fac = {user: {name: fac_name, email: "uffl@cin.ufpe.br", password: "adc", kind: "fac"}}
    post '/users', param_fac
    p param_fac
    fac = User.find_by(name: fac_name)
    expect(fac).to_not be nil
    
end

When(/^o facilitador "([^"]*)" faz uma requisicao de acesso para o laboratorio "([^"]*)"$/) do |fac_name, lab_name|
    
    param_lab = {laboratory: {name: lab_name, department: nil}}
    post '/laboratories', param_lab
    p_lab = Laboratory.find_by(name: lab_name)
    expect(p_lab).to_not be nil
    
end

When(/^o sistema verifica se o facilitador "([^"]*)" está associado a um laboratório\.$/) do |fac_name|
    
    param_fac = {user: {name: fac_name, email: "fac@hotmail.com", password: "aa", kind: "fac"}}
    post '/users', param_fac
    p_user = User.find_by(name: fac_name)
    expect(p_user).to_not be nil
    p_lab = Laboratory.find_by(user_id: p_user.id)
    expect(p_lab).to_not be !nil

end

Then(/^o sistema faz a requisicao do facilitador "([^"]*)" ao laboratorio "([^"]*)"$/) do |fac_name, lab_name|
    
    p_user = User.find_by(name: fac_name)
    p_lab = Laboratory.find_by(name: lab_name)
    expect(p_user).to_not be nil
    expect(p_lab).to_not be nil
    param_req = {request: {user_id: p_user.id, laboratory_id: p_lab.id}}
    post '/requests', param_req
    p_req = Request.find_by(user_id: p_user.id)
    expect(p_req).to_not be nil

end

Given(/^o adm "([^"]*)" esta asscoiado ao sistema$/) do |adm_name|
    param_adm = {user: {name: adm_name, email: "adm_name@ha.com", password: "blabla", kind: "adm"}}
    post '/users', param_adm
    adm = User.find_by(name: adm_name)
    expect(adm).to_not be nil
end

Then(/^o sistema faz uma notificacao avisando que o facilitador "([^"]*)" fez uma requisicao para o laboratorio "([^"]*)"$/) do |fac_name, lab_name|
    
    fac = User.find_by(name: fac_name)
    expect(fac).to_not be nil
    
    lab = Laboratory.find_by(name: lab_name)
    expect(lab).to_not be nil
    req = Request.find_by(user_id: fac.id)
    expect(req).to_not be nil

    param_not = {notification: {message: "Nova requisicao",request_id: req.id}}
    post '/notifications', param_not
    noti = Notification.find_by(request_id: req.id)
    expect(noti).to_not be nil

end

Then(/^o sistema envia um email para "([^"]*)" avisando que existe uma nova requisicao$/) do |arg1|
end
########## CENARIOS DE GUI

@req = nil

Given(/^eu estou na pagina de requisicoes$/) do
    visit '/requests'
end

Given(/^existe uma requisicao pendente$/) do
    visit 'users/new'
    fill_in('user_name', :with => "joc")
    fill_in('user_email', :with => "joc@cin.ufpe.br")
    fill_in('user_password', :with => "111")
    fill_in('user_kind', :with => "fac")
    click_button 'Create User'
    
    visit 'departments/new'
    fill_in('department_name', :with => "cin")
    click_button 'Create Department'
    
    visit 'laboratories/new'
    fill_in('laboratory_name', :with => "grad1")
    page.select "cin", :from => 'laboratory_department_id'
    click_button 'Create Laboratory'
    
    visit 'requests/new'
    @req = {user_name: "joc", lab_name: "grad1"}
    page.select "joc", :from => 'request_user_id'
    page.select "grad1", :from => 'request_laboratory_id'
    click_button 'Create Request'
    expect(page).to have_content "joc" 
    visit '/requests'

end

When(/^eu clico em aceitar$/) do
    click_on('Aceitar')   

end

Then(/^eu vejo que a requisicao nao aparece mais$/) do
    expect(page).to_not have_content @req[:user_name]
end



Given(/^o facilitador "([^"]*)" esta associado ao laboratorio de "([^"]*)"$/) do |fac_name, lab_name|
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
    
    visit '/requests'
    click_on('Aceitar')   

    ##clicar no botao aceitar 

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

################################### Cenários de @d9 até @d12 #############################################################

@request = nil
@user = nil

Given(/^que o facilitador de login "([^"]*)" está cadastrado no sistema$/) do |fac_name|
    param_fac = {user: {name: fac_name, email: "vrvs@cin.ufpe.br", password: "adc", kind: "fac"}}
    post '/users', param_fac
    fac = User.find_by(name: fac_name)
    expect(fac).to_not be nil
end

Given(/^o laboratório "([^"]*)" está cadastrado no sistema$/) do |lab_name|
   param_lab = {laboratory: {name: lab_name, department: nil}}
    post '/laboratories', param_lab
    p_lab = Laboratory.find_by(name: lab_name)
    expect(p_lab).to_not be nil
end

Given(/^existe uma solicitação de acesso do facilitador "([^"]*)" ao laboratório de "([^"]*)"$/) do |fac_name, lab_name|
   
    p_user = User.find_by(name: fac_name)
    p_lab = Laboratory.find_by(name: lab_name)
    expect(p_user).to_not be nil
    expect(p_lab).to_not be nil
    
    param_req = {request: {user_id: p_user.id, laboratory_id: p_lab.id}}
    post '/requests', param_req
    @request = Request.find_by(user_id: p_user.id)
    expect(@request).to_not be nil
    
end

When(/^o administrador rejeita a solicitação$/) do
  post 'refuse_request', :request => @request.id
end

Then(/^o sistema gera uma notificação de rejeição da solicitação$/) do

  param_not = {notification: {message: "rejeitaa"}}
  post '/notifications', param_not
  p_not = Notification.find_by(message: "rejeitaa")
  expect(p_not).to_not be nil 
  p_not.fac_id = @request.user_id
  
end

When(/^o administrador aceita a solicitação$/) do
  post 'accept_request', :request => @request.id
end

Then(/^o sistema gera uma notificação de aceitação da solicitação$/) do

  param_not = {notification: {message: "aceitaaa"}}
  post '/notifications', param_not
  p_not = Notification.find_by(message: "aceitaaa")
  expect(p_not).to_not be nil 
  p_not.fac_id = @request.user_id
  
end

Given(/^o facilitador de login "([^"]*)" é um usuário do sistema$/) do |fac_name|
  visit 'users/new'
    fill_in('user_name', :with => fac_name)
    fill_in('user_email', :with => "joc@cin.ufpe.br")
    fill_in('user_password', :with => "111")
    fill_in('user_kind', :with => "fac")
    click_button 'Create User'
end

Given(/^o facilitador "([^"]*)" solicitou acesso ao laboratório de "([^"]*)"$/) do |fac_name, lab_name|
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
    visit '/requests'
    
    @user = fac_name
end

When(/^o administrador clica no botão para rejeitar a solicitação$/) do
  click_on('Rejeitar')
end

When(/^o administrador clica no botão para aceitar a solicitação$/) do
  click_on('Aceitar')
end

Then(/^o facilitador vê uma notificação de aceitação de solicitação$/) do
  visit '/main_fac'
  
  element = find("td", text: "O administrador aceitou sua solicitação " + @user)
  
  expect(element).to_not be nil
end

Then(/^o facilitador vê uma notificação de rejeição de solicitação$/) do
  visit '/main_fac'
  
  element = find("td", text: "O administrador rejeitou sua solicitação " + @user)
  
  expect(element).to_not be nil
end
