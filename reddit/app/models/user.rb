# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :username, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: {minimum: 6, allow_nil: true}

    after_initialize :ensure_session_token

    attr_reader :password

    def self.find_by_credentials(username, pw)
        @user = User.find_by_username(username)

        if @user && @user.is_password?(pw)
            return @user
        end
        nil
    end

    def is_password?(pw)
        pw_obj = BCrypt::Password.new(self.password_digest)
        pw_obj.is_password?(pw)
    end

    def password=(pw)
        @password = pw
        self.password_digest = BCrypt::Password.create(pw)
    end

    def ensure_session_token
        self.session_token ||= SecureRandom.base64
    end

    def reset_session_token!
        self.session_token = SecureRandom.base64
        self.save!
        session_token
    end
end
