require 'rails_helper'

RSpec.describe 'When I open food show page', type: :feature do
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

    @food = Food.create(user: @user, name: 'Apple', measurement_unit: 'kg', price: 10, quantity: 4)
    sleep(1)
    visit(user_food_path(@user, @food))
  end

  it 'has successful status response' do
    expect(page).to have_http_status :ok
  end

  it 'shows information about the food' do
    expect(page).to have_content('Apple')
    expect(page).to have_content('kg')
    expect(page).to have_content('10.0')
    expect(page).to have_content('4')
  end

  it 'shows a button to delete food' do
    expect(page).to have_button('Delete')
  end
end
