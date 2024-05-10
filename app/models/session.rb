class Session
  include ActiveModel::Model
  attr_accessor :email, :code
  validates :email, :code, presence: true
  validates :email, format: {with: /\A.+@.+\z/}

  validate :check_validation_code

  def check_validation_code
    return if self.code.empty?
    return if Rails.env.development? && self.code == '123456'
    
    validation_code = ValidationCode.find_by(email: self.email, code: self.code, used_at: nil)
    if validation_code
      validation_code.update(used_at: Time.now)
    else
      self.errors.add :email, :not_found
    end
  end

end
