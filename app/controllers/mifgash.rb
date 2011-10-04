# -*- encoding : utf-8 -*-

Pinkas.controllers :mifgash, :parent => :kvutza do

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  get :new, :with => [:mahoz_id, :ken_id] do
    @kvutza = Kvutza.first :conditions => {:name => params[:kvutza_id]}
    @mifgash = @kvutza.mifgashim.new
    @mifgash.date = Date.today
    @mifgash.name = "מפגש חדש"
    render 'mifgash/new'
  end

  get :edit, :with => [:mahoz_id, :ken_id, :mifgash_id] do
    @kvutza = Kvutza.first :conditions => {:name => params[:kvutza_id]}
    @mifgash = Mifgash.first :conditions => {:name => params[:mifgash_id]}
    render 'mifgash/edit'
  end
  
  post :update, :with => [:mahoz_id, :ken_id, :mifgash_id] do
    @kvutza = Kvutza.first :conditions => {:name => params[:kvutza_id]}
    if params[:mifgash_id] == 'מפגש חדש'
      @mifgash = @kvutza.mifgashim.new
    else
      @mifgash = Mifgash.first :conditions => {:name => params[:mifgash_id]}
    end
    
    if params[:taxonomy]
      @mifgash.hanichim = params[:taxonomy].map { |t|
        if t[1] != '0'
          Hanich.find(t)
        end
      }
    else
      @mifgash.hanichim = []
    end
    
    @mifgash.update_attributes params[:mifgash]

    @kvutza.hanichim.each do |h|
      if @mifgash.hanichim.include? h
        h.mifgashim << @mifgash
      else
        h.mifgashim.delete @mifgash
      end
      h.save
    end
    
    redirect url(:kvutza_show, :kvutza_id => @mifgash.kvutza.name, :mahoz_id => @mifgash.kvutza.ken.mahoz.name, :ken_id => @mifgash.kvutza.ken.name)
  end
  
end
