class Mahoz
  include Mongoid::Document


  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  field :code, :type => Integer

  has_many :kenim, :class_name => 'Ken', :inverse_of => :mahoz
  
  has_and_belongs_to_many :rakazim, :class_name => 'Account', :inverse_of => :mahozot
  
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
  
  def kenim_ids
    @kenim_ids = []
    kenim.each do |k|
      @kenim_ids.push( k._id )
    end
    return @kenim_ids
  end
 
  def kvutzot_ids
    @kvutzot_ids = []
    kenim.each do |ken|
      ken.kvutzot.each do |k|
        @kvutzot_ids.push( k._id )
      end
    end
    return @kvutzot_ids
  end

end
