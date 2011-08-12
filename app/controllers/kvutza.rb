Pinkas.controllers :kvutza do
  include CanCan::ControllerAdditions
  
  get :new, :map => "/:mahoz/:ken/new" do
    authorize! :new, Kvutza
    @ken = Ken.first :conditions => {:name => params[:ken]}
    @kvutza = @ken.kvutzot.new
    render 'kvutza/new'
  end
  
  get :show, :map => "/:mahoz/:ken/:kvutza" do
    @kvutza = Kvutza.first :conditions => {:name => params[:kvutza]}
    authorize! :show, @kvutza
    @mifgashim = @kvutza.mifgashim.order_by([[:date, :desc]])
    @graph = {'m' => [], 'f' => []}
    @kvutza.mifgashim.order_by([[:date, :asc]]).each_with_index do |m, i|
      @graph['m'][i] = [m.date.to_time.to_i*1000, m.boys]
      @graph['f'][i] = [m.date.to_time.to_i*1000, m.girls]
    end

    render 'kvutza/show'
  end
  
  
  post :update, :map => "/:mahoz/:ken/:kvutza_name" do
    if params[:kvutza_name] == 'new'
      @ken = Ken.first :conditions => {:name => params[:ken]}
      @kvutza = @ken.kvutzot.new
    else
      @kvutza = Kvutza.first :conditions => {:name => params[:kvutza_name]}
    end
    authorize! :update, @kvutza
    @kvutza.update_attributes params[:kvutza]
    redirect url(:ken, :show, {:ken => @ken.name, :mahoz => @ken.mahoz.name})
  end
  
  error CanCan::AccessDenied do
    redirect "/login"
  end

end
