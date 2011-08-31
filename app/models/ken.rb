class Ken
  include Mongoid::Document

  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  field :code, :type => Integer

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>
  
  has_many :kvutzot, :class_name => 'Kvutza', :inverse_of => :ken
  belongs_to :mahoz, :class_name => 'Mahoz', :inverse_of => :kenim

  has_and_belongs_to_many :commonarim, :class_name => 'Account', :inverse_of => :kenim_commonar
  has_and_belongs_to_many :rakazim, :class_name => 'Account', :inverse_of => :kenim_rakaz
  
  accepts_nested_attributes_for :rakazim, :allow_destroy => true, :reject_if => proc { |attributes| attributes["name"].blank? }
  accepts_nested_attributes_for :commonarim, :allow_destroy => true, :reject_if => proc { |attributes| attributes["name"].blank? }
  #embeds_many :rakazim, :class_name => "Account", :inverse_of => :kenim_rakaz
  
 

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
  
  def rakazim_names
    @rakazim_names = ""
    self.rakazim.each do |r|
      @rakazim_names = @rakazim_names + r.name + ", "
    end
    return @rakazim_names.chop.chop!
  end
  
  def kvutzot_ids
    @kvutzot_ids = []
    kvutzot.each do |k|
      @kvutzot_ids.push( k._id )
    end
    return @kvutzot_ids
  end
  
end
