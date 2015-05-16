class Tag

  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String
  field :desc, type: String
  field :level, type: Integer, default: 1
  field :weight, type: Integer, default: 1
  field :vocabulary, type: String # maintain, buy, sell, etc
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  belongs_to :parent, class_name: "Tag"
  
  attr_accessor :children
  
  def add_child(name, options = {})
    children = Tag.where(parent: self).order_by(:weight.desc)
    
    weight = 1
    if options[:weight]
      weight = options[:weight]
    else
      if children.first
        weight = children.first.weight + 1
      end
    end
    
    Tag.create!(name: name, level: self.level + 1, weight: weight, parent: self, vocabulary: self.vocabulary)
  end
end