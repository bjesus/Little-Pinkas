Pinkas.controllers :hanich do

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  get :new, :with => [:mahoz_id, :kvutza_id, :ken_id] do
    @kvutza = Kvutza.first :conditions => {:name => params[:kvutza_id]}
    @hanich = @kvutza.hanichim.new
    @shchavot = Shichva.all
    @hanich.first_name = "חניך"
    @hanich.last_name = "חדש"
    render 'hanich/new'
  end
  
  get :show, :with => [:hanich_id, :mahoz_id, :kvutza_id, :ken_id] do
    @hanich = Hanich.first :conditions => {:first_name => params[:hanich_id].split[0], :last_name => params[:hanich_id].split[1]}
    render 'hanich/show'
  end
  

  get :edit, :with => [:hanich_id, :mahoz_id, :kvutza_id, :ken_id] do
    @hanich = Hanich.first :conditions => {:first_name => params[:hanich_id].split[0], :last_name => params[:hanich_id].split[1]}
    @shchavot = Shichva.all
    render 'hanich/edit'
  end
  
  post :update, :with => [:hanich_id, :mahoz_id, :kvutza_id, :ken_id] do
    if params[:hanich_id] == 'חניך חדש'
      @kvutza = Kvutza.first :conditions => {:name => params[:kvutza_id]}
      @hanich = @kvutza.hanichim.new
    else
      @hanich = Hanich.first :conditions => {:first_name => params[:hanich_id].split[0], :last_name => params[:hanich_id].split[1]}
    end
    @hanich.update_attributes params[:hanich]
    redirect url(:kvutza_show, :kvutza_id => @hanich.kvutza.name, :mahoz_id => @hanich.kvutza.ken.mahoz.name, :ken_id => @hanich.kvutza.ken.name)
  end
  
end
