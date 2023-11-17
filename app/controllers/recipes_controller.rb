class RecipesController < ApplicationController
  load_and_authorize_resource

  def index
    @recipes = current_user.recipes.order(id: :asc)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @recipe_foods = @recipe.recipe_foods.includes(:food)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    if @recipe.save
      flash[:success] = 'recipe created successfully!'
      redirect_to recipes_url
    else
      flash.now[:error] = 'Error: recipe could not be created!'
      render :new, locals: { recipe: @recipe }
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy!
    flash[:success] = 'Recipe deleted successfully!'
    redirect_to recipes_url
  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.public
      @recipe.update!(public: false)
      flash[:notice] = 'Recipe status changed to private'
    else
      @recipe.update!(public: true)
      flash[:notice] = 'Recipe status changed to public'
    end
    redirect_to recipe_path
  end

  def public_recipes
    @recipes = Recipe.includes([:user, { recipe_foods: [:food] }]).where(public: true).order(id: :asc)
    @recipes_with_food_info = @recipes.map do |recipe|
      {
        recipe:,
        total_food_items: recipe.recipe_foods.size,
        total_price: recipe.recipe_foods.sum { |recipe_food| recipe_food.food.price * recipe_food.quantity }
      }
    end
  end

  def shopping_list
    @recipe = Recipe.includes([recipe_foods: [:food]]).find(params[:recipe_id])
    @recipe_data = {
      total_food_items: @recipe.recipe_foods.size,
      total_price: @recipe.recipe_foods.sum { |recipe_food| recipe_food.food.price * recipe_food.quantity }
    }
    # @recipe_foods = @recipe.recipe_foods.includes(:food)
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description, :public)
  end
end
