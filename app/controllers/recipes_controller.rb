class RecipesController < ApplicationController
  load_and_authorize_resource

  def index
    @user = User.find(current_user.id)
    @recipes = @user.recipes.order(id: :asc)
    # @recipes = @recipes.paginate(page: params[:page], per_page: 5)
  end

  def show
    @recipe = Recipe.find(params[:id])
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
    flash[:success] = 'recipe was deleted successfully!'
    redirect_to recipes_url
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description, :public)
  end
end
