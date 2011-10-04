# -*- encoding : utf-8 -*-
class Account
  include Mongoid::Document
  attr_accessor :password, :password_confirmation

  # Fields
  field :name,             :type => String
  field :surname,          :type => String
  field :email,            :type => String
  field :crypted_password, :type => String
  field :role,             :type => String
  field :birthday,         :type => Date
  field :tz,               :type => String

  # Validations
  validates_presence_of     :email, :tz, :name, :surname
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  
  # Relations
  
  has_and_belongs_to_many :kenim_rakaz, :class_name => 'Ken', :inverse_of => :rakazim
  has_and_belongs_to_many :kenim_commonar, :class_name => 'Ken', :inverse_of => :commonarim
  has_and_belongs_to_many :kvutzot, :class_name => 'Kvutza', :inverse_of => :madrichim

  # Callbacks
  before_save :encrypt_password, :if => :password_required
  before_validation :fill_details

  ##
  # This method is for authentication purpose
  #
  def self.authenticate(email, password)    
    require 'net/http'
    require 'uri'

    begin
      info = Net::HTTP.get URI.parse('http://levadom.noal.org.il/madrichim/tafkidim?user='+email)
      data = JSON.parse(info)
    rescue
      return false
    end
    # let's create the user
    user = Account.first(:conditions => {:email => email})
    if user == nil
      user = Account.create :email => email, :tz => data['tz'], :name => data['first_name'], :surname => data['last_name'], :password => data['tz']
    end
    user.save!

    # now let's give him some tafkidim
    data['tafkidim'].each do |tafkid|
      case tafkid['tafkid']['level']
      when 1
        user.role = "madrich"
      when 4
        user.role = "commonar"
        ken = Ken.find_or_create_by :code => tafkid['moked']['code']
        if not ken.commonarim.include? user
          ken.commonarim << user
        end
        ken.name = tafkid['moked']['he']
        ken.mahoz = Mahoz.find_or_create_by :code => tafkid['moked']['code'].to_s.slice(0,2)
        ken.save!
      when 6
        user.role = "rakaz_ken"
        ken = Ken.find_or_create_by :code => tafkid['moked']['code']
        if not ken.rakazim.include? user
          ken.rakazim << user
        end
        ken.name = tafkid['moked']['he']
        ken.mahoz = Mahoz.find_or_create_by :code => tafkid['moked']['code'].to_s.slice(0,2)
        ken.save!
      when 7
        user.role = "rakaz_mahoz"
        mahoz = Mahoz.find_or_create_by :code => tafkid['moked']['code']
        if not mahoz.rakazim.include? user
          mahoz.rakazim << user
        end
        mahoz.name = tafkid['moked']['he']
        mahoz.save!
      end
      user.save!
    end
    account = first(:conditions => { :email => email }) if email.present?
    account && account.has_password?(password) ? account : nil
  end

  ##
  # This method is used by AuthenticationHelper
  #
  def self.find_by_id(id)
    find(id) rescue nil
  end

  def full_name
    self.name + " " + self.surname
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  private
    def encrypt_password
      self.crypted_password = ::BCrypt::Password.create(self.password)
    end

    def password_required
      crypted_password.blank? || self.password.present?
    end
    
    def fill_details
      self.password = self.password_confirmation = self.tz
      if self.kvutzot.length > 0
        self.role = "madrich"
      end
      if self.kenim_rakaz.length > 0
        self.role = "rakaz_ken"
      end
    end
end
