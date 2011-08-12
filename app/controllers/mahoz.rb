Pinkas.controllers :mahoz do
  include CanCan::ControllerAdditions

  get :show, :map => "/:mahoz" do
    authorize! :show, Mahoz
    @mahoz = Mahoz.first :conditions => {:name => params[:mahoz]}


    @graph = {'m' => [], 'f' => []}
    Mifgash.mahoz(@mahoz).all.order_by([[:date, :asc]]).each_with_index do |m, i|
      @graph['m'][i] = [m.date.to_time.to_i*1000, m.boys]
      @graph['f'][i] = [m.date.to_time.to_i*1000, m.girls]
    end
    render 'mahoz/show'
  end
  
end


