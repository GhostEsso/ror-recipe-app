require 'rails_helper'

RSpec.describe 'When I open user index page', type: :feature do
  before(:each) do
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

  it 'shows quantity placeholder 1' do
    expect(page).to have_selector("input#recipe_food_quantity[value='3']")
  end

  it 'shows food name in dropbox' do
    expect(page).to have_select(options: %w[Apple Pear])
  end

  it 'shows Update button' do
    expect(page).to have_button('Update')
  end

  context 'When I click on Update button' do
    it 'redirects me back to the recipe where the Ingredient is present' do
      fill_in 'Quantity', with: '5'
      click_button('Update')
      expect(page).to have_current_path(recipe_path(@recipe))
    end

    it 'displays the updated quantity' do
      fill_in 'Quantity', with: '5'
      click_button('Update')
      expect(page.html).to include('<td>5</td>')
    end

    it 'recalculates the value' do
      fill_in 'Quantity', with: '5'
      click_button('Update')
      expect(page.html).to include('<td>50.0</td>')
    end

    it 'recalculates the value' do
      select 'Pear', from: 'recipe_food[food_id]'
      click_button('Update')
      expect(page.html).to include('<td>Pear</td>')
    end
  end
end
