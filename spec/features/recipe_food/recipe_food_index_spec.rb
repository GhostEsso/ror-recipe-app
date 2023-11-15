require 'rails_helper'

RSpec.describe 'When I open user index page', type: :feature do
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
    @recipe_food2 = RecipeFood.create(recipe: @recipe, food: @food2, quantity: 7)

    visit(recipe_path(@recipe))
  end

  it 'has successful status response' do
    expect(page).to have_http_status :ok
  end

  it 'shows the correct table headings' do
    expect(page).to have_content('Food')
    expect(page).to have_content('Quantity')
    expect(page).to have_content('Value')
    expect(page).to have_content('Actions')
  end

  it 'shows food name for each food' do
    expect(page).to have_content('Apple')
    expect(page).to have_content('Pear')
  end

  it 'shows correct quantity for each food' do
    expect(page).to have_content('3')
    expect(page).to have_content('7')
  end

  it 'calculates the right value for each ingredient' do
    expect(page).to have_content('30')
    expect(page).to have_content('70')
  end

  context 'When I click on Edit button' do
    it 'redirects me to form that adds Ingredient' do
      within first('.ingredient') do
        click_link('Edit')
      end
      expect(page).to have_current_path(edit_recipe_recipe_food_path(@recipe, @recipe_food1))
    end
  end

  context 'When I click on Delete button' do
    it 'removes this ingredient' do
      within first('.ingredient') do
        click_button('Delete')
      end
      expect(page).to_not have_content('Apple')
    end
  end
end
