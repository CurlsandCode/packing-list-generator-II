class ItemsController < ApplicationController

  def index
    if params[:trip_id]
      @trip = Trip.find(params[:trip_id])
      @items = @trip.items
    elsif params[:category_id]
      @items = Category.find(params[:category_id]).items
    else
      @items = current_user.trips.collect{|t| t.items}.flatten.uniq
    end
    render json: @items
  end

  def list
    @trip = Trip.find(params[:format])
    @items = @trip.items
    render 'index'
  end


  def edit
    @item = Item.find(params[:id])
    @trip = Trip.find(params[:trip_id])
    @trip_item = @trip.trip_items.find_by(item_id: @item.id)
  end

  def update
    @item_check = Item.new(:name => params[:item][:items][:name])
    @trip = Trip.find(params[:trip_id])
    @trip_item = @trip.trip_items.find_by(item_id: params[:id])
    if @item_check.valid?
      @item = Item.find(params[:id])
      @item.name = params[:item][:items][:name]
      @trip_item.quantity = params[:trip_item][:quantity]
      @trip_item.save
      @item.save
      redirect_to items_list_path(@trip)
    else
      @item = Item.find(params[:id])
      render '/items/edit'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @trip = Trip.find(params[:trip_id])
    @trip_item = @trip.trip_items.find_by(item_id: @item.id)
    @trip_item.delete
    redirect_to items_list_path(@trip)
  end

  private

  def item_params
    params.require(:item).permit(:name, :category_id, :description, trip_ids:[], trip_attributes: [:title, :year, :category])
  end
end
