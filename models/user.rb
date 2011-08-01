class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String, :unique => true
  property :password_hash, String
  property :character_count, Integer

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

  def characters
    unless self.character_count 
      self.character_count = definitions.map(&:translation).compact.map(&:length).inject(&:+)
      self.save
    end
    self.character_count
  end

  private

  def self.encode(str)
    Digest::SHA1.hexdigest(str)
  end
end
