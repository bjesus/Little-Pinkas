# -*- encoding : utf-8 -*-
Admin.controllers :haniches do

  get :index do
    @haniches = Hanich.all
    render 'haniches/index'
  end

  get :new do
    @hanich = Hanich.new
    render 'haniches/new'
  end

  post :create do
    @hanich = Hanich.new(params[:hanich])
    if @hanich.save
      flash[:notice] = 'Hanich was successfully created.'
      redirect url(:haniches, :edit, :id => @hanich.id)
    else
      render 'haniches/new'
    end
  end

  get :edit, :with => :id do
    @hanich = Hanich.find(params[:id])
    render 'haniches/edit'
  end

  put :update, :with => :id do
    @hanich = Hanich.find(params[:id])
    if @hanich.update_attributes(params[:hanich])
      flash[:notice] = 'Hanich was successfully updated.'
      redirect url(:haniches, :edit, :id => @hanich.id)
    else
      render 'haniches/edit'
    end
  end

  delete :destroy, :with => :id do
    hanich = Hanich.find(params[:id])
    if hanich.destroy
      flash[:notice] = 'Hanich was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Hanich!'
    end
    redirect url(:haniches, :index)
  end
end
