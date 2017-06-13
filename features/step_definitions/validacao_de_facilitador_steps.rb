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
    page.select "joc", :from => 'request_user_id'
    page.select "grad1", :from => 'request_laboratory_id'
    click_button 'Create Request'
        expect(page).to have_content "joc" 
    
end

When(/^eu clico em aceitar$/) do
    #find(:xpath, "//tbody/tr/td/form.button_to", text: 'Aceitar').click
    #find(:css, ".button_to[value='Aceitar']").click_button
    #page.show have_css("#table", text: => 'Aceitar')
    #find(:button, "//tbody/tr/td/form.button_to/Aceitar").click
  #click_button('//tr/td/Aceitar')
  find(:xpath,:text => 'Aceitar').click
end

Then(/^eu vejo que a requisicao nao aparece mais$/) do
  pending # Write code here that turns the phrase above into concrete actions
end





Given(/^eu estou logado como adminstrador$/) do
   visit '/main_adm'
end

When(/^eu entro na pagina de solicitacoes de acesso$/) do
    visit '/requests'
end
###### fazer uma pagina mostrando as solicitacoes pendentes 
Then(/^eu aceito as solicitacoes pendentes$/) do
      click_button 'Aceitar'
      
end



Given(/^o facilitador "([^"]*)" esta associado ao laboratorio de "([^"]*)"$/) do |fac_name, lab_name|
    visit 'users/new'
    fill_in('user_name', :with => fac_name)
    fill_in('user_email', :with => "joc@cin.ufpe.br")
    fill_in('user_password', :with => "111")
    fill_in('user_kind', :with => "fac")
    click_button 'Create User'
    
    fac = User.find_by(name: fac_name)
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
    
    click_button 'Aceitar'
    ##clicar no botao aceitar 

end

When(/^o facilitador "([^"]*)" faz uma requisição de acesso para o laboratório "([^"]*)"$/) do |lab_name|
    
    visit 'laboratories/new'
    fill_in('laboratory_name', :with => lab_name)
    page.select "cin", :from => 'laboratory_department_id'
    click_button 'Create Laboratory'
    
end

Then(/^eu vejo uma mensagem informando que o facilitador "([^"]*)" ja esta associado a um laboratório$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end