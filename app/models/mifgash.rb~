class Mifgash
  include Mongoid::Document

  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  field :kind, :type => String
  field :location, :type => String
  field :date, :type => Date
  
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>
  
  belongs_to :kvutza, :class_name => 'Kvutza', :inverse_of => :mifgashim
  
  has_and_belongs_to_many :hanichim, :class_name => 'Hanich', :inverse_of => :mifgashim
  
  scope :ken, lambda{ |ken| where(:kvutza_id.in => ken.kvutzot_ids) }
  scope :mahoz, lambda{ |mahoz| where(:kvutza_id.in => mahoz.kvutzot_ids) }


  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>

  def boys
    count = 0
    hanichim.each do |h|
      if h.gender == "בן"
        count += 1
      end
    end
    @boys = count
  end

  def girls
    count = 0
    hanichim.each do |h|
      if h.gender == "בת"
        count += 1
      end
    end
    @girls = count
  end
  
  def sum
    @sum = boys + girls
  end



end
