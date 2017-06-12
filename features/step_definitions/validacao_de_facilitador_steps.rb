Given(/^que o facilitador de login "([^"]*)" não está associado a nenhum laboratório$/) do |fac_name|
    
    param_fac = {user: {name: fac_name, email: "uffl@cin.ufpe.br", password: "adc", kind: "fac"}}
    post '/users', param_fac
    p param_fac
    p fac_name
    fac = User.find_by(name: fac_name)
    p fac
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
    p p_req
    
end

Given(/^o adm "([^"]*)" esta asscoiado ao sistema$/) do |adm_name|
    param_adm = {user: {name: adm_name, email: "adm_name@ha.com", password: "blabla", kind: "adm"}}
    post '/users', param_adm
    p param_adm
    adm = User.find_by(name: adm_name)
    p param_adm
    expect(adm).to_not be nil
end

Then(/^o sistema faz uma notificacao avisando que o facilitador "([^"]*)" fez uma requisicao para o laboratorio "([^"]*)"$/) do |fac_name, lab_name|
    
    fac = User.find_by(name: fac_name)
    expect(fac).to_not be nil
    
    lab = Laboratory.find_by(name: lab_name)
    expect(lab).to_not be nil
    p fac.id
    req = Request.find_by(user_id: fac.id)
    expect(req).to_not be nil

    param_not = {notification: {message: "Nova requisicao",request_id: req.id}}
    post '/notifications', param_not
    noti = Notification.find_by(request_id: req.id)
    expect(noti).to_not be nil

end

Then(/^o sistema envia um email para "([^"]*)" avisando que existe uma nova requisicao$/) do |arg1|
end

Given(/^eu estou logado como adm$/) do
   

end

When(/^eu entro na pagina "([^"]*)"$/) do |page|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^eu aceito as solicitacoes pendentes$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^eu aceito as solicitações pendentes$/) do
  pending # Write code here that turns the phrase above into concrete actions
end