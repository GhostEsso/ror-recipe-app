class FoodsController < ApplicationController
  def index
    @foods = Food.all.order(:name)
  end

  def show
    set_food
  end

  def create
    @food = Food.new(food_params)
    @food.user = current_user
    if @food.save
      redirect_to @food, notice: 'Food was successfully created.'
    else
      render 'new'
    end
  end

  def destroy
    set_food
    @food.destroy!
    redirect_to foods_path, notice: 'Successfully destroyed foodlist.'
  end

  private

  def food_params
    params.require(:food).permit(:name, :measurement_unit, :price, :quantity)
  end

  def set_food
    @food = Food.find(params[:id])
  end
end
