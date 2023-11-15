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

    @recipe1 = Recipe.create(user: @user, name: 'Greek Salad', description: 'This is my favourite salad!',
                             preparation_time: 0, cooking_time: 0)
    @recipe2 = Recipe.create(user: @user, name: 'Japanese Salad', description: 'I love this recipe very much! ' * 5,
                             preparation_time: 0, cooking_time: 0)
    visit(recipes_path)
  end

  it 'has successful status response' do
    expect(page).to have_http_status :ok
  end

  it 'shows the correct heading' do
    expect(page).to have_content('My Recipes')
  end

  it 'shows the names of all recipes' do
    expect(page).to have_content('Greek Salad')
    expect(page).to have_content('Japanese Salad')
  end

  it 'shows the truncated description of all recipes' do
    str = 'I love this recipe very much! I love this recipe very much! I love this recipe very much! I love ...'
    expect(page).to have_content('This is my favourite salad!')
    expect(page).to have_content(str)
  end

  it 'shows the REMOVE button 2 times' do
    expect(page).to have_button('REMOVE', count: 2)
  end

  it 'shows the Add Recipe button' do
    expect(page).to have_link('Add Recipe', href: new_recipe_path)
  end

  context 'When I click on a Recipe name' do
    it "redirects me to that recipe's show page" do
      click_link('Greek Salad')
      expect(page).to have_current_path(recipe_path(@recipe1))
    end

    it "redirects me to that recipe's show page" do
      click_link('Japanese Salad')
      expect(page).to have_current_path(recipe_path(@recipe2))
    end
  end

  context 'When I click on a Add Recipe button' do
    it 'redirects me to form that adds Recipe' do
      click_link('Add Recipe')
      expect(page).to have_current_path(new_recipe_path)
    end
  end

  context 'When I click on REMOVE button' do
    it 'removes this item' do
      within first('.single_recipe') do
        click_button('REMOVE')
      end
      expect(page).to_not have_content('Greek Salad')
    end
  end
end
