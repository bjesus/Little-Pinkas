# -*- encoding : utf-8 -*-
Pinkas.controllers :mahoz do
  include CanCan::ControllerAdditions

  get :show, :with => :mahoz_id do
    @mahoz = Mahoz.first :conditions => {:name => params[:mahoz_id]}
    authorize! :show, @mahoz
    @graph = {'m' => [], 'f' => []}
    Mifgash.mahoz(@mahoz).all.order_by([[:date, :asc]]).each_with_index do |m, i|
      @graph['m'][i] = [m.date.to_time.to_i*1000, m.boys]
      @graph['f'][i] = [m.date.to_time.to_i*1000, m.girls]
    end
    render 'mahoz/show'
  end
  
end


