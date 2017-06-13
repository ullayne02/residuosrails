class Request < ApplicationRecord
  belongs_to :user
  belongs_to :laboratory
  has_one :notification, dependent: :destroy
  
  def check_fac
      lab = Laboratory.find_by(user_id: self.user_id)
      user = User.find_by(id: self.user_id)
      #p lab.name + " " + user.name 
      if lab != nil && user != nil then 
         Notification.create(message: "Facilitador " + user.name + " ja esta associado a um laboratorio", request_id: self.id)
      end
  end
  def notification_request
    lab = Laboratory.find_by(id: self.laboratory_id)
    user = User.find_by(id: self.user_id)
    if lab != nil && user != nil then 
      Notification.create(message: "Facilitador " + user.name + " fez um pedido de acesso ao laboratorio " + lab.name)
    end
  end
  
end
