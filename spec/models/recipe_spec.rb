require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:valid_attributes) { { 'user' => @user, 'name' => 'Greek Salad', 'preparation_time' => 0, 'cooking_time' => 0 } }
  let(:no_name) { { 'user' => @user, 'preparation_time' => 0, 'cooking_time' => 0 } }
  let(:name_too_long) { { 'user' => @user, 'name' => '0' * 251, 'preparation_time' => 0, 'cooking_time' => 0 } }
  let(:description_too_long) do
    { 'user' => @user, 'name' => 'Greek Salad', 'description' => '0' * 2001, 'preparation_time' => 0,
      'cooking_time' => 0 }
  end
  let(:preparation_time_string) do
    { 'user' => @user, 'name' => 'Greek Salad', 'preparation_time' => 'five', 'cooking_time' => 0 }
  end
  let(:preparation_time_float) do
    { 'user' => @user, 'name' => 'Greek Salad', 'preparation_time' => 1.5, 'cooking_time' => 0 }
  end
  let(:preparation_time_negative) do
    { 'user' => @user, 'name' => 'Greek Salad', 'preparation_time' => -2, 'cooking_time' => 0 }
  end
  let(:preparation_time_integer) do
    { 'user' => @user, 'name' => 'Greek Salad', 'preparation_time' => 5, 'cooking_time' => 0 }
  end

  before :all do
    @user = User.create(name: 'Tom', email: 'tom@example.com', password: 'topsecret')
  end

  context '#create validates required fields' do
    it 'is valid with existing name' do
      expect(Recipe.new(valid_attributes)).to be_valid
    end

    it 'is not valid with blank name' do
      expect(Recipe.new(no_name)).to_not be_valid
    end
  end

  context '#create validates the length of name and desctiption' do
    it 'is not valid with name exceeding 250 characters' do
      expect(Recipe.new(name_too_long)).to_not be_valid
    end

    it 'is not valid with name exceeding 2000 characters' do
      expect(Recipe.new(description_too_long)).to_not be_valid
    end
  end

  context '#create validates preparation_time data type' do
    it 'is not valid with non-numeric preparation_time' do
      expect(Recipe.new(preparation_time_string)).to_not be_valid
    end

    it 'is valid with float preparation_time' do
      expect(Recipe.new(preparation_time_float)).to be_valid
    end

    it 'is not valid with negative preparation_time' do
      expect(Recipe.new(preparation_time_negative)).to_not be_valid
    end

    it 'is valid with integer preparation_time' do
      expect(Recipe.new(preparation_time_integer)).to be_valid
    end
  end
end
