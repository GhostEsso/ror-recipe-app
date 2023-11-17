require 'rails_helper'

RSpec.describe 'When I open food index page', type: :feature do
  before(:each) do
    User.delete_all
    @user = User.create(name: 'Lily', email: 'lily@example.com', password: 'topsecret')
    @user_extra = User.create(name: 'Kiki', email: 'kiki@example.com', password: 'topsecret')

    @user.confirm
    visit new_user_session_path
    fill_in 'Email', with: 'lily@example.com'
    fill_in 'Password', with: 'topsecret'
    click_button 'Log in'
    sleep(1)

    @food1 = Food.create(user: @user, name: 'Apple', measurement_unit: 'kg', price: 10, quantity: 4)
    @food2 = Food.create(user: @user, name: 'Pear', measurement_unit: 'kg', price: 12, quantity: 5)
    @food3 = Food.create(user: @user_extra, name: 'Mango', measurement_unit: 'kg', price: 2, quantity: 2)
    sleep(1)
    visit(foods_path)
  end

  it 'has successful status response' do
    expect(page).to have_http_status :ok
  end

  it 'shows a list of all foods' do
    expect(page).to have_content('Apple')
    expect(page).to have_content('Pear')
    expect(page).to_not have_content('Mango')
  end

  it 'shows a button to add new food' do
    expect(page).to have_link('Add food', href: new_food_path)
  end

  it 'shows a button to delete food' do
    expect(page).to have_button('Remove').twice
  end
end
