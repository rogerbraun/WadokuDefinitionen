class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String
  property :password_hash, String
  
  def self.authenticate(params)
    User.first(:email => params[:email], :password_hash => encode(params[:password]))
  end

  def password=(pw)
    self.password_hash = encode(pw)
  end

  private

  def self.encode(str)
    Digest::SHA1.hexdigest(str)
  end
end
