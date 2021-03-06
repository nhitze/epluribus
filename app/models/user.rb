class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :trackable, :rememberable,
         :omniauthable, :omniauth_providers => [:google_oauth2]

  has_and_belongs_to_many :editor_projects, class_name: 'Project', join_table: 'projects_editors'

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:email => data["email"]).first

      unless user
          user = User.create(name: data["name"],
               email: data["email"],
               avatar: data["image"],
               password: Devise.friendly_token[0,20]
          )
      end
      user
  end

  def avatar
    attributes['avatar'] || 'no-avatar.png'
  end
end
