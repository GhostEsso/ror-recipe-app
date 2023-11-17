require 'rails_helper'

RSpec.describe 'When I open recipe edit page', type: :feature do
  before(:each) do
    User.delete_all
    @user = User.create(name: 'Tom', email: 'tom@example.com', password: 'topsecret')
    @user.confirm
    sleep(1)

    visit new_user_session_path
    fill_in 'Email', with: 'tom@example.com'
    fill_in 'Password', with: 'topsecret'
    click_button 'Log in'
    sleep(1)

    @food1 = Food.create(user: @user, name: 'Apple', measurement_unit: 'kg', price: 10, quantity: 4)
    @food2 = Food.create(user: @user, name: 'Pear', measurement_unit: 'kg', price: 10, quantity: 5)
    @recipe = Recipe.create(user: @user, name: 'Greek Salad', description: 'This is my favourite salad!',
                            preparation_time: 0, cooking_time: 0)
    @recipe_food1 = RecipeFood.create(recipe: @recipe, food: @food1, quantity: 3)
    visit(edit_recipe_recipe_food_path(@recipe, @recipe_food1))
    sleep(1)
  end

  it 'has successful status response' do
    expect(page).to have_http_status :ok
  end

  it 'shows the correct heading' do
    expect(page).to have_content('Edit Ingredient')
  end

  it 'shows quantity field' do
    expect(page).to have_content('Quantity')
  end

  it 'shows recipe food quantity' do
    expect(page).to have_field('recipe_food[quantity]', with: 3, type: 'number')
  end

  it 'shows food name in dropbox' do
    expect(page).to have_select(options: %w[Apple Pear])
  end

  it 'shows Update button' do
    expect(page).to have_button('Save changes')
  end

  context 'When I click on save changes button' do
    it 'redirects me back to the recipe where the Ingredient is present' do
      fill_in 'recipe_food[quantity]', with: 5
      click_button('Save changes')
      expect(page).to have_current_path(recipe_path(@recipe))
    end

    it 'displays the updated quantity' do
      fill_in 'recipe_food[quantity]', with: 7
      click_button('Save changes')
      visit(edit_recipe_recipe_food_path(@recipe, @recipe_food1))
      expect(page).to have_field('recipe_food[quantity]', with: 7, type: 'number')
    end
  end

  it 'selects a different food ingredient' do
    select 'Pear', from: 'recipe_food[food_id]'
    click_button('Save changes')
    visit(edit_recipe_recipe_food_path(@recipe, @recipe_food1))
    expect(page).to have_field('recipe_food[food_id]', with: @food2.id)
  end
end
