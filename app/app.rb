class Pinkas < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
  register CompassInitializer
  register Padrino::Rendering
  register Padrino::Admin::AccessControl
  
  set :session_secret, "30f69df151e7ce96ecfe3855819d63a7a0544f018e4d9df136ceceaf73943574"
  set :sessions, true

  ##
  # Caching support
  #
  # register Padrino::Cache
  # enable :caching
  #
  # You can customize caching store engines:
  #
  #   set :cache, Padrino::Cache::Store::Memcache.new(::Memcached.new('127.0.0.1:11211', :exception_retry_limit => 1))
  #   set :cache, Padrino::Cache::Store::Memcache.new(::Dalli::Client.new('127.0.0.1:11211', :exception_retry_limit => 1))
  #   set :cache, Padrino::Cache::Store::Redis.new(::Redis.new(:host => '127.0.0.1', :port => 6379, :db => 0))
  #   set :cache, Padrino::Cache::Store::Memory.new(50)
  #   set :cache, Padrino::Cache::Store::File.new(Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
  #

  ##
  # Application configuration options
  #
  set :raise_errors, true     # Raise exceptions (will stop application) (default true for development)
  set :show_exceptions, true  # Show a stack trace in browser (default is true)
  set :public, "public"      # Location for static assets (default root/public)
  # set :reload, false          # Reload application files (default in development)
  # set :default_builder, "foo" # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"     # Set path for I18n translations (defaults to app/locale/)
  enable :sessions            # Disabled by default
  # disable :flash              # Disables rack-flash (enabled by default if sessions)
  # disable :padrino_logging    # Disables Padrino logging (enabled by default)
  # layout  :my_layout          # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  #

  ##
  # You can configure for a specified environment like:
  #
  #   configure :development do
  #     set :foo, :bar
  #     disable :asset_stamp # no asset timestamping for dev
  #   end
  #

  ##
  # You can manage errors like:
  #
  #   error 404 do
  #     render 'errors/404'
  #   end
  #
  #   error 505 do
  #     render 'errors/505'
  #   end
  #
  
  error do 
    #if $!.kind_of?(MyExceptionBase) 
    #  error $!.http_status, $!.description 
    #else 
    #  error 500, "Server Error" 
    #end 
    redirect "/login"
  end 

  
  error CanCan::AccessDenied do
    redirect "/login"
  end
  
  enable :authentication
  disable :store_location
  
  set :login_page, "/login"

end


# include this in app file

# this is for Role Based Access Controle, can be much shorter
class Ability
  include CanCan::Ability

  def initialize account
    @abilities ||= {}

    allow :madrich do
      can :show, Kvutza do |kvutza|
        kvutza.madrichim_ids.include? account.id
      end
    end

    allow :commonar do
      can :show, Kvutza do |kvutza|
        kvutza.ken.commonarim_ids.include? account.id
      end
      can :show, Ken do |ken|
        ken.commonarim_ids.include? account.id
      end
      can :update, Kvutza
      can :new, Kvutza
    end

    allow :rakaz_ken do
      can :show, Kvutza do |kvutza|
        kvutza.ken.rakazim_ids.include? account.id
      end
      can :show, Ken do |ken|
        ken.rakazim_ids.include? account.id
      end
      can :update, Kvutza
      can :new, Kvutza
    end  

    allow :rakaz_mahoz do
      can :show, Kvutza do |kvutza|
        kvutza.ken.mahoz.rakazim_ids.include? account.id
      end
      can :show, Ken do |ken|
        ken.mahoz.rakazim_ids.include? account.id
      end
      can :show, Mahoz do |mahoz|
        mahoz.rakazim_ids.include? account.id
      end
      can :update, Ken
      can :new, Ken
      can :update, Kvutza
      can :new, Kvutza
    end  

    allow :admin do
      can :accounts, :index
    end

    role = account.role.to_sym rescue :any
    (@abilities[role] || []).each do |block|
      block.call
    end
  end

  def allow roles, &block
    if roles.is_a? Array
      roles.each do |role| allow_role role, &block end
    else
      allow_role roles, &block 
    end
  end

  def allow_role role, &block
    @abilities[role] ||= []
    @abilities[role] << block
  end
end


# include this in app file
module CanCan
  module ControllerAdditions
    def current_user
      current_account
    end

    def self.included(base)
      base.extend ClassMethods
      # base.helper_method :can?, :cannot?, :current_ability
    end
  end
end

