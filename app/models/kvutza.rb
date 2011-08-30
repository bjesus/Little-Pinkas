class Kvutza
  include Mongoid::Document
  
  
  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  field :code, :type => Integer
  
  has_many :hanichim, :class_name => 'Hanich', :inverse_of => :kvutza
  has_many :mifgashim, :class_name => 'Mifgash', :inverse_of => :kvutza

  belongs_to :ken, :class_name => 'Ken', :inverse_of => :kvutzot
  belongs_to :shichva, :class_name => 'Shichva', :inverse_of => :kvutzot

  has_and_belongs_to_many :madrichim, :class_name => 'Account', :inverse_of => :kvutzot

  validates_presence_of :name
  validates_presence_of :code

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
  
  def activity
    spark = ''
    latest_mifgashim = mifgashim.limit(10).desc([:date])
    latest_mifgashim.each do |m|
      spark = spark + m.hanichim.count.to_s+","
    end
    @activity = spark.chop!
  end
  
  def gender_stats
    spark = ''
    latest_mifgashim = mifgashim.limit(10).desc([:date])
    latest_mifgashim.each do |m|
      spark = spark + m.hanichim.count.to_s+","
    end
    @activity = spark.chop!
  end
  
end
