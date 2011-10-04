# -*- encoding : utf-8 -*-

Pinkas.controllers :kvutza, :parent => :ken do
  include CanCan::ControllerAdditions
  
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
  
  error CanCan::AccessDenied do
    redirect "/login"
  end

end
