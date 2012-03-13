class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = User.where(:email => data.email).first
      user
    else # Create a user with a stub password. 
      # data = access_token.keys
      # logger.debug 'at -- '+access_token['credentials']['token'].to_s
      fb_user = FbGraph::User.new('me',:access_token => access_token['credentials']['token']).fetch
      fb_id = access_token['uid']
      fb_email = fb_user.email
      fb_gender = fb_user.gender
      fb_name = fb_user.name
      u = User.new
      u.email = fb_email
      # u.name = fb_name
      u.password = Devise.friendly_token[0,20]
      # u.fb_id = fb_id
      # u.gender = fb_gender
      # u.name = fb_name
      u.save
      u
    end
  end
  
  
  
  def self.new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"]
        end
      end
    end
  
end
