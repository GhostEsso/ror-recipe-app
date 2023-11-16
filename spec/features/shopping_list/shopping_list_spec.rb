require 'rails_helper'

RSpec.describe 'When I open shopping list page', type: :feature do
  before(:each) do
    User.delete_all
    @user = User.create(name: 'Lily', email: 'lily@example.com', password: 'topsecret')

    @user.confirm
    visit new_user_session_path
    fill_in 'Email', with: 'lily@example.com'
    fill_in 'Password', with: 'topsecret'
    click_button 'Log in'
    sleep(1)

    @food1 = Food.create(user: @user, name: 'Apple', measurement_unit: 'kg', price: 10, quantity: 4)
    @food2 = Food.create(user: @user, name: 'Pear', measurement_unit: 'kg', price: 12, quantity: 5)
    @recipe = Recipe.create(user: @user, name: 'Japanese Salad', description: 'I love this recipe very much! ' * 5,
                            preparation_time: 1, cooking_time: 2, public: true)

    @recipe_food1 = RecipeFood.create(recipe: @recipe, food: @food1, quantity: 3)
    @recipe_food2 = RecipeFood.create(recipe: @recipe, food: @food2, quantity: 7)
    sleep(1)
    visit(shopping_list_path(@recipe))
  end

  it 'renders page correctly' do
    expect(page).to have_http_status :ok
  end

  it 'shows the amount of items to buy' do
    within('div#recipe-info') do
      expect(page).to have_content('Amount of food items to buy: 2')
    end
  end

  it 'shows the total price' do
    within('div#recipe-info') do
      expect(page).to have_content('Total value of food needed: $114.0')
    end
  end

  it 'shows the ingredient names' do
    within('table.table') do
      expect(page).to have_content(@food1.name)
      expect(page).to have_content(@food2.name)
    end
  end

  it 'shows the ingredient quantities' do
    within first('.food-quantity') do
      expect(page).to have_content('4 kg')
    end
    within all('.food-quantity').last do
      expect(page).to have_content('5 kg')
    end
  end

  it 'shows the ingredient prices' do
    within first('.food-price') do
      expect(page).to have_content('$40.0')
    end
    within all('.food-price').last do
      expect(page).to have_content('$60.0')
    end
  end
end
