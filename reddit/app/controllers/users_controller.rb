class UsersController < ApplicationController

    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            login!(@user)
    end


    private
    def user_params
        params.require(:user).permit(:username, :password)
    end
end

# name="user[username]"

# params = { id = "", action ="" user = {username: mendy, password: password}}