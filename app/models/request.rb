class Request < ApplicationRecord
  belongs_to :user
  belongs_to :laboratory
  has_one :notification, dependent: :destroy
  
  def check_fac
      lab = Laboratory.find_by(user_id: self.user_id)
      user = User.find_by(id: self.user_id)
      #p lab.name + " " + user.name 
      if lab != nil && user != nil then 
         notif = Notification.create(message: "Facilitador " + user.name + " ja esta associado a um laboratorio", request_id: self.id)
         notif.fac_id = 0
         notif.save
      end
  end
  
end
