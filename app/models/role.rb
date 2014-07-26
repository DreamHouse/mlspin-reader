class Role

  include Mongoid::Document
  include Mongoid::Timestamps
  
  # admin, agent, partner, standard
  field :type, type: String
  
  def admin?
    self.type == 'admin'
  end
end