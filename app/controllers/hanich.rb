Pinkas.controllers :hanich do

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  get :new, :map => "/:mahoz/:ken/:kvutza/new" do
    @kvutza = Kvutza.first :conditions => {:name => params[:kvutza]}
    @hanich = @kvutza.hanichim.new
    render 'hanich/new'
  end
  
  get :show, :map => "/:mahoz/:ken/:kvutza/:hanich" do
    @hanich = Hanich.first :conditions => {:first_name => params[:hanich].split[0], :last_name => params[:hanich].split[1]}
    render 'hanich/show'
  end
  

  get :edit, :map => "/:mahoz/:ken/:kvutza/:hanich/edit" do
    @hanich = Hanich.first :conditions => {:first_name => params[:hanich].split[0], :last_name => params[:hanich].split[1]}
    render 'hanich/edit'
  end
  
  post :update, :map => "/:mahoz/:ken/:kvutza/:hanich_name" do
    puts params[:hanich]
    if params[:hanich_name] == 'new'
      @kvutza = Kvutza.first :conditions => {:name => params[:kvutza]}
      @hanich = @kvutza.hanichim.new
    else
      @hanich = Hanich.first :conditions => {:first_name => params[:hanich_name].split[0], :last_name => params[:hanich_name].split[1]}
    end
    @hanich.update_attributes params[:hanich]
    redirect url(:kvutza, :show, {:kvutza => @hanich.kvutza.name, :mahoz => "sds", :ken => "asa"})
  end
  
end
