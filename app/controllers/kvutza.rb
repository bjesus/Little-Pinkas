Pinkas.controllers :kvutza, :parent => :ken do
  include CanCan::ControllerAdditions
  
  get :new, :with => :mahoz_id do
    authorize! :new, Kvutza
    @ken = Ken.first :conditions => {:name => params[:ken_id]}
    @shchavot = Shichva.all
    @kvutza = @ken.kvutzot.new
    @kvutza.name = "קבוצה חדשה"
    @kvutza.madrichim << Account.new(:kvutzot => [@kvutza], :role => "madrich")
    render 'kvutza/new'
  end
  
  get :show, :with => [:kvutza_id, :mahoz_id] do
    @kvutza = Kvutza.first :conditions => {:name => params[:kvutza_id]}
    authorize! :show, @kvutza
    @mifgashim = @kvutza.mifgashim.order_by([[:date, :desc]])
    @graph = {'m' => [], 'f' => []}
    @kvutza.mifgashim.order_by([[:date, :asc]]).each_with_index do |m, i|
      @graph['m'][i] = [m.date.to_time.to_i*1000, m.boys]
      @graph['f'][i] = [m.date.to_time.to_i*1000, m.girls]
    end
    render 'kvutza/show'
  end
  
  get :edit, :with => [:kvutza_id, :mahoz_id] do
    @kvutza = Kvutza.first :conditions => {:name => params[:kvutza_id]}
    @shchavot = Shichva.all
    @kvutza.madrichim << Account.new(:kvutzot => [@kvutza], :role => "madrich")
    render 'kvutza/edit'
  end
  
  post :update, :with => [:kvutza_id, :mahoz_id] do
    if params[:kvutza_id] == 'קבוצה חדשה'
      @ken = Ken.first :conditions => {:name => params[:ken_id]}
      @kvutza = @ken.kvutzot.new
    else
      @kvutza = Kvutza.first :conditions => {:name => params[:kvutza_id]}
      @ken = @kvutza.ken
    end
    authorize! :update, @kvutza
    @kvutza.update_attributes! params[:kvutza]
    redirect url(:ken_show, :ken_id => @ken.name, :mahoz_id => @ken.mahoz.name)
  end
  
  error CanCan::AccessDenied do
    redirect "/login"
  end

end
