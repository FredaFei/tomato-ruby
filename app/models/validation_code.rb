class ValidationCode < ApplicationRecord
  validates :email, presence: true
  # email 必须是合法的邮箱地址
  validates :email, format: {with: /\A.+@.+\z/}
  
end
