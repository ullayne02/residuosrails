class Collection < ApplicationRecord
  has_many :residues
  has_many :reports, dependent: :destroy
  has_one :notification, dependent: :destroy
  
  validates :max_value, presence: true
  
  
  
  attr_accessor :porcent, :mean, :miss_days, :miss_weight, :solido_organico, :solido_inorganico, :liquido_organico, :liquido_inorganico, :liquido_inflamavel, :outros
  
  
  def generate_prediction
    collection = Collection.last
    weight = 0.0
    Register.all.each do |register|
      weight += register.weight
    end
    time = Date.today - collection.created_at.to_date
    mean = weight/time
    miss_weight = (collection.max_value - weight)
    miss_days = miss_weight/mean
    miss_days = miss_days.ceil
    @mean=mean
    @miss_days=miss_days
    @miss_weight=miss_weight
  end
  
  def type_residue
    @solido_organico = 0.0
    @solido_inorganico = 0.0
    @liquido_organico = 0.0
    @liquido_inorganico = 0.0
    @liquido_inflamavel = 0.0
    @outros  = 0.0
    Register.all.each do |register|
      residue = Residue.find_by(id: register.residue_id)
      case residue.kind
      when "Sólido Orgânico"
        @solido_organico += register.weight
      when "Sólido Inorgânico"
        @solido_inorganico += register.weight
      when "Líquido Orgânico"
        @liquido_organico += register.weight
      when "Líquido Inorgânico"
        @liquido_inorganico += register.weight
      when "Líquido Inflamável"
        @liquido_inflamavel += register.weight
      when "Outros"
        @outros += register.weight
      end
    end
  end
  
  def generate_notification
    total_weight = 0
    col = Collection.last
    col.porcent = 0.93333333
    
    Residue.all.each do |res|
      total_weight += res.registers.where(created_at: [col.created_at..Time.now]).sum(:weight)
    end
    
    if total_weight > col.max_value
      if(col.notification != nil)
        notif = Notification.find_by(collection_id: col.id)
        notif.destroy
      end
      notif = Notification.create(message: "Passou do peso limite, deve fazer uma licitação", collection_id: col.id)
      
      
    elsif total_weight > (col.max_value*col.porcent)
      if(col.notification != nil)
        notif = Notification.find_by(collection_id: col.id)
        notif.destroy
      end
      Notification.create(message: "O peso está próximo do peso mínimo para fazer uma licitação", collection_id: col.id)
      
    end
    
  end
end
