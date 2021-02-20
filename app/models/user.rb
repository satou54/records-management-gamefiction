class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable #, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :tasks, dependent: :destroy
  has_many :action_records, dependent: :destroy
  has_many :user_levels, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
end
