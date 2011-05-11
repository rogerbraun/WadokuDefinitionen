class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String, :unique => true
  property :password_hash, String
  
  def self.authenticate(params)
    User.first(:email => params[:email], :password_hash => User.encode(params[:password]))
  end

  def password=(pw)
    self.password_hash = User.encode(pw)
  end

  private

  def self.encode(str)
    Digest::SHA1.hexdigest(str)
  end
end
