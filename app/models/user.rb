class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :tasks, dependent: :destroy
  has_many :action_records, dependent: :destroy
end
