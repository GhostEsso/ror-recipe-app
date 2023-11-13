class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthale
    devise :database_authenticatable, :registrable,
            :recoverable, :rememberable, :validatable, :confirmable
end
