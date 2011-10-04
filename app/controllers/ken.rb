# -*- encoding : utf-8 -*-
Pinkas.controllers :ken, :parent => :mahoz do
  include CanCan::ControllerAdditions

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
  
end
