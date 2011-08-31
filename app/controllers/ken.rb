Pinkas.controllers :ken, :parent => :mahoz do
  include CanCan::ControllerAdditions

  get :new do
    authorize! :new, Ken
    @mahoz = Mahoz.first :conditions => {:name => params[:mahoz_id]}
    @ken = @mahoz.kenim.new
    @ken.name = "קן חדש"
    @ken.rakazim << Account.new(:kenim_rakaz => [@ken], :role => "rakaz_ken")
    @ken.commonarim << Account.new(:kenim_commonar => [@ken], :role => "commonar")
    render 'ken/new'
  end

  get :edit, :with => :ken_id do
    @ken = Ken.first :conditions => {:name => params[:ken_id]}
    authorize! :edit, @ken
    @ken.rakazim << Account.new(:kenim_rakaz => [@ken], :role => "rakaz_ken")
    @ken.commonarim << Account.new(:kenim_commonar => [@ken], :role => "commonar")
    render 'ken/edit'
  end

  get :show, :with => :ken_id do
    @ken = Ken.first :conditions => {:name => params[:ken_id]}
    authorize! :show, @ken
    @graph = {'m' => [], 'f' => []}
    Mifgash.ken(@ken).all.order_by([[:date, :asc]]).each_with_index do |m, i|
      @graph['m'][i] = [m.date.to_time.to_i*1000, m.boys]
      @graph['f'][i] = [m.date.to_time.to_i*1000, m.girls]
    end
    render 'ken/show'
  end

  post :update, :with => :ken_id do
    if params[:ken_id] == 'קן חדש'
      @mahoz = Mahoz.first :conditions => {:name => params[:mahoz_id]}
      @ken = @mahoz.kenim.new
    else
      @ken = Ken.first :conditions => {:name => params[:ken_id]}
      @mahoz = @ken.mahoz
    end
    authorize! :update, @ken    
    @ken.update_attributes! params[:ken]
    redirect url(:mahoz_show, {:mahoz_id => @mahoz.name})
  end
  
end
