# -*- encoding : utf-8 -*-
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
    @hanich.slug = "חניך חדש"
    render 'hanich/new'
  end
  
  get :show, :with => [:hanich_id, :mahoz_id, :kvutza_id, :ken_id] do
    @hanich = Hanich.find_by_slug params[:hanich_id]
    render 'hanich/show'
  end
  

  get :edit, :with => [:hanich_id, :mahoz_id, :kvutza_id, :ken_id] do
    @hanich = Hanich.find_by_slug params[:hanich_id]
    @shchavot = Shichva.all
    render 'hanich/edit'
  end
  
  post :update, :with => [:hanich_id, :mahoz_id, :kvutza_id, :ken_id] do
    if params[:hanich_id] == 'חניך חדש'
      @kvutza = Kvutza.first :conditions => {:name => params[:kvutza_id]}
      @hanich = @kvutza.hanichim.new
    else
      @hanich = Hanich.find_by_slug params[:hanich_id]
    end
    @hanich.update_attributes params[:hanich]
    redirect url(:kvutza_show, :kvutza_id => @hanich.kvutza.name, :mahoz_id => @hanich.kvutza.ken.mahoz.name, :ken_id => @hanich.kvutza.ken.name)
  end
  
end
