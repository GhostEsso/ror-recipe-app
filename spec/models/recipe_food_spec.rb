require 'rails_helper'

RSpec.describe RecipeFood, type: :model do
  let(:valid_attributes) { { 'recipe' => @recipe, 'food' => @food, 'quantity' => 0 } }
  let(:no_food) { { 'recipe' => @recipe, 'quantity' => 0 } }
  let(:no_recipe) { { 'food' => @food, 'quantity' => 0 } }
  let(:no_quantity) { { 'recipe' => @recipe, 'food' => @food } }
  let(:quantity_string) { { 'recipe' => @recipe, 'food' => @food, 'quantity' => 'five' } }
  let(:quantity_float) { { 'recipe' => @recipe, 'food' => @food, 'quantity' => 1.5 } }
  let(:quantity_negative) { { 'recipe' => @recipe, 'food' => @food, 'quantity' => -2 } }
  let(:quantity_integer) { { 'recipe' => @recipe, 'food' => @food, 'quantity' => 5 } }

  before :all do
    @user = User.create(name: 'Tom', email: 'tom@example.com', password: 'topsecret')
    @recipe = Recipe.create(user: @user, name: 'Greek Salad', preparation_time: 0, cooking_time: 0)
    @food = Food.create(user: @user, name: 'Tomato', measurement_unit: 'kg', price: 10, quantity: 2)
  end

  context '#create validates required fields' do
    it 'is valid with existing quantity' do
      expect(RecipeFood.new(valid_attributes)).to be_valid
    end

    it 'is not valid with blank quantity' do
      expect(RecipeFood.new(no_quantity)).to_not be_valid
    end

    it 'is not valid without recipe' do
      expect(RecipeFood.new(no_recipe)).to_not be_valid
    end

    it 'is not valid without food' do
      expect(RecipeFood.new(no_food)).to_not be_valid
    end
  end

  context '#create validates quantity data type' do
    it 'is not valid with non-numeric quantity' do
      expect(RecipeFood.new(quantity_string)).to_not be_valid
    end

    it 'is valid with float quantity' do
      expect(RecipeFood.new(quantity_float)).to_not be_valid
    end

    it 'is not valid with negative quantity' do
      expect(RecipeFood.new(quantity_negative)).to_not be_valid
    end

    it 'is valid with integer quantity' do
      expect(RecipeFood.new(quantity_integer)).to be_valid
    end
  end
end
