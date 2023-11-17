class RecipeFoodsController < ApplicationController
  def index; end

  def show; end

  def new
    @recipe_food = RecipeFood.new
  end

  def create
    @recipe_food = RecipeFood.new(recipe_food_params)
    @recipe_food.recipe_id = params[:recipe_id]
    if @recipe_food.save
      flash[:success] = 'recipe_food created successfully!'
      redirect_to recipe_url(params[:recipe_id])
    else
      flash.now[:error] = 'Error: recipe_food could not be created!'
      render :new, locals: { recipe_food: @recipe_food }
    end
  end

  def destroy
    set_recipe_food
    @recipe_food.destroy
    redirect_to recipe_url(params[:recipe_id])
  end

  def edit
    set_recipe_food
  end

  def update
    set_recipe_food
    if @recipe_food.update(recipe_food_params)
      redirect_to recipe_url(params[:recipe_id])
    else
      render 'edit'
    end
  end

  private

  def set_recipe_food
    @recipe_food = RecipeFood.find(params[:id])
  end

  def recipe_food_params
    params.require(:recipe_food).permit(:quantity, :food_id)
  end
end
