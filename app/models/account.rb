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
  field :tz,               :type => Integer

  # Validations
  validates_presence_of     :email, :role, :birthday, :tz
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of       :role,     :with => /[A-Za-z]/
  
  
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
    account = first(:conditions => { :email => email }) if email.present?
    account && account.has_password?(password) ? account : nil
  end

  ##
  # This method is used by AuthenticationHelper
  #
  def self.find_by_id(id)
    find(id) rescue nil
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
