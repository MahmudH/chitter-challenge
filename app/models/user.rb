require 'bcrypt'

class User

include DataMapper::Resource

  attr_accessor :password_confirmation
  attr_accessor :password

  validates_confirmation_of :password
  validates_presence_of :email
  validates_uniqueness_of :email

# writes to the database -------------
  property :id, Serial
  property :username, Text, required: true
  property :email, String, required: true
  property :password_digest, Text
  # property :password, String
  # property :password_confirmation, String

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email,password)
    user = first(email: email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end

  def password_token
    self.password_token_timestamp = Time.now
    self.password_token = "DMFYOMLYCESXAFPYFRATHPTKLULDPOVIHUIOZIIPSRLCQV"
  end

end
