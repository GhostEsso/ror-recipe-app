require 'rails_helper'

RSpec.describe 'When I open recipe new page', type: :feature do
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
    visit(new_recipe_recipe_food_path(@recipe))
  end

  it 'has successful status response' do
    expect(page).to have_http_status :ok
  end

  it 'shows the correct heading' do
    expect(page).to have_content('Add New Ingredient')
  end

  it 'shows quantity field' do
    expect(page).to have_content('Quantity')
  end

  it 'shows quantity placeholder 1' do
    expect(page).to have_selector("input#recipe_food_quantity[value='1']")
  end

  it 'shows food name in dropbox' do
    expect(page).to have_select(options: %w[Apple Pear])
  end

  it 'has correct Add New Food link' do
    expect(page).to have_link('Add new food', href: new_food_path)
  end

  it 'shows Add Ingredient button' do
    expect(page).to have_button('Add new ingredient')
  end

  context 'When I click on Add Ingredient button' do
    it 'redirects me back to the recipe where the Ingredient is present' do
      click_button('Add new ingredient')
      expect(page).to have_current_path(recipe_path(@recipe))
      expect(page).to have_content('Apple')
    end
  end

  context 'When I click on Add New Food link' do
    it 'redirects me to form that adds Ingredient' do
      click_link('Add new food')
      expect(page).to have_current_path(new_food_path)
    end
  end
end
