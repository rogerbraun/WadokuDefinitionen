class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String, :unique => true
  property :password_hash, String

  has n, :definitions
  
  def self.authenticate(params)
    User.first(:email => params[:email], :password_hash => User.encode(params[:password]))
  end

  def password=(pw)
    self.password_hash = User.encode(pw)
  end

  def gravatar_tag
    "<img src='http://gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email.downcase.strip)}?d=retro' alt='#{email}'"
  end

  private

  def self.encode(str)
    Digest::SHA1.hexdigest(str)
  end
end
