Pinkas.controllers :home do
  include CanCan::ControllerAdditions

  get :logout, :map => "/help" do
    render 'accounts/help'
  end

  get :login, :map => "/login" do
    render 'accounts/new'
  end

  get :logout, :map => "/logout" do
    set_current_account(nil)
    redirect "/login"
  end

  post :login_action, :map => "/login" do
    set_current_account(Account.authenticate(params[:email], params[:password]))
    redirect "/"
  end

  get :home, :map => "/" do
    if logged_in?
      if current_user.role == 'madrich'
        @kvutza = Kvutza.first(:conditions => { :madrichim_ids => current_account.id })
        redirect "/"+@kvutza.ken.mahoz.name+"/"+@kvutza.ken.name+"/"+@kvutza.name
      elsif current_user.role == 'commonar'
        @ken = Ken.first(:conditions => { :commonarim_ids => current_account.id })
        redirect "/"+@ken.mahoz.name+"/"+@ken.name
      elsif current_user.role == 'rakaz_ken'
        @ken = Ken.first(:conditions => { :rakazim_ids => current_account.id })
        redirect "/"+@ken.mahoz.name+"/"+@ken.name
      elsif current_user.role == 'rakaz_mahoz'
        @mahoz = Mahoz.first(:conditions => { :rakazim_ids => current_account.id })
        redirect "/"+@mahoz.name
      elsif current_user.role == 'admin'
        redirect "/admin"
      end
    else
      redirect "/login"
    end
  end

end
