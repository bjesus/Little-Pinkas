# -*- encoding : utf-8 -*-
class Hanich
  include Mongoid::Document
  include Mongoid::Slug

  # field <name>, :type => <type>, :default => <value>
  field :first_name
  field :last_name, :type => String
  field :tz, :type => Integer
  field :phone, :type => String
  field :phone_2, :type => String
  field :address, :type => String
  field :dad, :type => String
  field :mom, :type => String
  field :tax, :type => Boolean

  slug :first_name, :last_name
  
  belongs_to :kvutza, :class_name => 'Kvutza', :inverse_of => :hanichim
  belongs_to :shichva, :class_name => 'Shichva', :inverse_of => :hanichim

  has_and_belongs_to_many :mifgashim, :class_name => 'Mifgash', :inverse_of => :hanichim

  validates_presence_of :first_name, :last_name
 
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
  
  def full_name
    begin
      first_name + " " + last_name
    rescue
      "new"
    end
  end
  
  def activity
   spark = ''
   latest_mifgashim = kvutza.mifgashim.limit(10).desc([:date])
   latest_mifgashim.each do |m|
     if m.hanichim.include? self
       spark = spark + "1,"
     else
       spark = spark + "0,"
     end
   end
   @activity = spark.chop!
  end
end
