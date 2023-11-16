require 'rails_helper'

RSpec.describe 'When I open food new page', type: :feature do
  before(:each) do
    User.delete_all
    @user = User.create(name: 'Lily', email: 'lily@example.com', password: 'topsecret')

    @user.confirm
    visit new_user_session_path
    fill_in 'Email', with: 'lily@example.com'
    fill_in 'Password', with: 'topsecret'
    click_button 'Log in'
    sleep(1)

    @recipe = Recipe.create(user: @user, name: 'Japanese Salad', description: 'I love this recipe very much! ' * 5,
                            preparation_time: 1, cooking_time: 2, public: true)

    sleep(1)
    visit(new_food_path)
  end

  it 'has successful status response' do
    expect(page).to have_http_status :ok
  end

  it 'creates new food' do
    fill_in 'Name', with: 'Apple'
    fill_in 'Measurement unit', with: 'kg'
    fill_in 'Price', with: 10
    fill_in 'Quantity', with: 4
    click_button 'Create Food'
    expect(page).to have_content('Food was successfully created.')
  end

  it 'checks that new food is added to the list' do
    fill_in 'Name', with: 'Apple'
    fill_in 'Measurement unit', with: 'kg'
    fill_in 'Price', with: 10
    fill_in 'Quantity', with: 4
    click_button 'Create Food'
    visit(foods_path)
    expect(page).to have_content('Apple')
  end
end
