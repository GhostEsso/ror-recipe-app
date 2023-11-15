class RecipesController < ApplicationController
  load_and_authorize_resource

  def index
    @recipes = current_user.recipes.order(id: :asc)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @recipe_foods = @recipe.recipe_foods
    # @recipe_foods = RecipeFood.find_by_recipe_id(params[:id])
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
    @recipes = Recipe.where(public: true).order(id: :asc)
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description, :public)
  end
end
