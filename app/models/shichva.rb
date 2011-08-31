class Shichva
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  field :age, :type => Integer
  
  
  has_many :hanichim, :class_name => 'Hanich', :inverse_of => :shichva
  has_many :kvutzot, :class_name => 'Kvutza', :inverse_of => :shicvha
  

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
