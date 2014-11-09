class Town

  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String
  field :state, type: String # Am I going to support other states ever?

  # Belmont, MA is definitely hot
  # hot town: 5
  # warm town: 4
  # normal: 3
  # cold: 0
  field :hotness, type: Integer, default: 0 

  validates_uniqueness_of :name
end