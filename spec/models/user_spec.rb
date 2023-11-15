require 'rails_helper'

RSpec.describe User, type: :model do
  context '#create validates required fields' do
    it 'is valid with existing name, email and password' do
      expect(User.create(name: 'Tom', email: 'tommy@example.com', password: 'topsecret')).to be_valid
    end

    it 'is not valid with blank name' do
      expect(User.create(email: 'tom@example.com', password: 'topsecret')).to_not be_valid
    end

    it 'is not valid with blank email' do
      expect(User.create(name: 'Tom', password: 'topsecret')).to_not be_valid
    end

    it 'is not valid with blank password' do
      expect(User.create(name: 'Tom', email: 'tom@example.com')).to_not be_valid
    end
  end
end
